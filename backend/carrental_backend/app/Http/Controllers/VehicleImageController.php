<?php

namespace App\Http\Controllers;

use App\Models\VehicleImage;
use App\Models\Vehicle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VehicleImageController extends Controller
{
    public function index(Request $request)
    {
        $vehicleId = $request->query('vehicle_id');
        if ($vehicleId) {
            return response()->json(VehicleImage::where('vehicle_id', $vehicleId)->get());
        }
        return response()->json(VehicleImage::all());
    }

    public function store(Request $request)
    {
        $user = Auth::guard('sanctum')->user();

        $validated = $request->validate([
            'vehicle_id'  => 'required|exists:vehicles,vehicle_id',
            'image_url'   => 'required|url|max:255',
            'description' => 'nullable|string|max:255',
        ]);

        // Csak a jármű tulajdonosa vagy admin tölthet fel képet
        $vehicle = Vehicle::findOrFail($validated['vehicle_id']);
        if ($user->role !== 'admin' && $vehicle->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        // Max 5 kép ellenőrzése
        $count = VehicleImage::where('vehicle_id', $validated['vehicle_id'])->count();
        if ($count >= 5) {
            return response()->json(['error' => 'Egy járműhöz maximum 5 kép adható meg.'], 422);
        }

        $image = VehicleImage::create($validated);
        return response()->json($image, 201);
    }

    public function destroy($id)
    {
        $user = Auth::guard('sanctum')->user();
        $image = VehicleImage::findOrFail($id);
        $vehicle = Vehicle::findOrFail($image->vehicle_id);

        if ($user->role !== 'admin' && $vehicle->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $image->delete();
        return response()->json(['message' => 'Deleted']);
    }

    public function show($id)
    {
        return response()->json(VehicleImage::findOrFail($id));
    }

    public function update(Request $request, $id)
    {
        $user = Auth::guard('sanctum')->user();
        $image = VehicleImage::findOrFail($id);
        $vehicle = Vehicle::findOrFail($image->vehicle_id);

        if ($user->role !== 'admin' && $vehicle->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'image_url'   => 'sometimes|url|max:255',
            'description' => 'nullable|string|max:255',
        ]);

        $image->update($validated);
        return response()->json($image);
    }
}
