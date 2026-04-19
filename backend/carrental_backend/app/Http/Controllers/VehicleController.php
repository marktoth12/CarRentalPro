<?php

namespace App\Http\Controllers;

use App\Models\Vehicle;
use Illuminate\Http\Request;

class VehicleController extends Controller
{
    public function index()
    {
        return Vehicle::with('images', 'rentalAgent')->paginate(15);
    }

    public function show($id)
    {
        return Vehicle::with('images', 'rentalAgent', 'rentals')->findOrFail($id);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'make' => 'required|string|max:50',
            'model' => 'required|string|max:50',
            'year' => 'required|digits:4',
            'license_plate' => 'required|string|unique:vehicles|max:10',
            'daily_rate' => 'required|numeric|min:0',
            'description' => 'nullable|string',
            'fuel_type' => 'required|in:petrol,diesel,electric,hybrid',
            'transmission_type' => 'required|in:manual,automatic',
            'number_of_seats' => 'required|integer|min:1',
            'location_pickup' => 'required|string|max:100',
            'location_return' => 'required|string|max:100',
        ]);

        $validated['rentalagent_id'] = auth()->id();
        $vehicle = Vehicle::create($validated);

        return response()->json($vehicle, 201);
    }

    public function update(Request $request, $id)
    {
        $vehicle = Vehicle::findOrFail($id);
        $this->authorize('update', $vehicle);

        $validated = $request->validate([
            'make' => 'string|max:50',
            'model' => 'string|max:50',
            'year' => 'digits:4',
            'daily_rate' => 'numeric|min:0',
            'description' => 'nullable|string',
            'fuel_type' => 'in:petrol,diesel,electric,hybrid',
            'transmission_type' => 'in:manual,automatic',
            'number_of_seats' => 'integer|min:1',
            'location_pickup' => 'string|max:100',
            'location_return' => 'string|max:100',
            'is_available' => 'boolean',
        ]);

        $vehicle->update($validated);
        return $vehicle;
    }

    public function destroy($id)
    {
        $vehicle = Vehicle::findOrFail($id);
        $this->authorize('delete', $vehicle);
        $vehicle->delete();

        return response()->noContent();
    }
}

