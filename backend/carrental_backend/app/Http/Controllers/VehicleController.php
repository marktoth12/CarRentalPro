<?php

namespace App\Http\Controllers;

use App\Models\Vehicle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VehicleController extends Controller
{
    public function index(Request $request)
    {
        if ($request->query('dashboard')) {
            $user = Auth::guard('sanctum')->user();

            if (!$user) {
                return response()->json(['error' => 'Unauthorized'], 401);
            }

            // Admin: az összes jármű
            if ($user->role === 'admin') {
                return response()->json(Vehicle::with('images')->get());
            }

            // Rentalagent: csak a saját járművei
            return response()->json(
                Vehicle::where('rentalagent_id', $user->user_id)
                    ->with('images')
                    ->get()
            );
        }

        // Publikus lista: csak jóváhagyott járművek
        return response()->json(Vehicle::where('is_approved', 1)->with('images')->get());
    }

    public function show($id)
    {
        return response()->json(
            Vehicle::where('vehicle_id', $id)->with('images', 'rentalAgent')->firstOrFail()
        );
    }

    public function store(Request $request)
    {
        $user = Auth::guard('sanctum')->user();

        if (!$user || $user->role !== 'rentalagent') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'brand' => 'required|string|max:50',
            'model' => 'required|string|max:50',
            'year' => 'required|integer',
            'license_plate' => 'required|string|unique:vehicles,license_plate',
            'daily_rate' => 'required|numeric',
            'fuel_type' => 'required|in:petrol,diesel,electric,hybrid',
            'transmission_type' => 'required|in:manual,automatic',
            'number_of_seats' => 'required|integer',
            'location_pickup' => 'required|string|max:100',
            'location_return' => 'required|string|max:100',
            'description' => 'nullable|string'
        ]);

        $vehicle = Vehicle::create(array_merge($validated, [
            'rentalagent_id' => $user->user_id,
            'is_approved' => 0,
            'is_available' => 1
        ]));

        return response()->json($vehicle, 201);
    }

    public function update(Request $request, $id)
    {
        $user = Auth::guard('sanctum')->user();
        $vehicle = Vehicle::where('vehicle_id', $id)->firstOrFail();

        if (!$user || ($user->user_id !== $vehicle->rentalagent_id && $user->role !== 'admin')) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $vehicle->update($request->all());
        return response()->json($vehicle);
    }

    public function destroy($id)
    {
        $user = Auth::guard('sanctum')->user();
        $vehicle = Vehicle::where('vehicle_id', $id)->firstOrFail();

        if (!$user || ($user->user_id !== $vehicle->rentalagent_id && $user->role !== 'admin')) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $activeRentals = \App\Models\Rental::where('vehicle_id', $id)
            ->whereIn('rental_status', ['pending_approval', 'approved', 'in_progress'])
            ->exists();

        if ($activeRentals) {
            return response()->json(['error' => 'A járműnek aktív bérlése van, nem törölhető.'], 422);
        }

        \App\Models\Rental::where('vehicle_id', $id)->delete();
        $vehicle->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
