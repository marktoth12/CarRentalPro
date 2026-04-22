<?php

namespace App\Http\Controllers;

use App\Models\Rental;
use Illuminate\Http\Request;

class RentalController extends Controller
{
    public function index(Request $request)
    {
        $user = auth()->user();

        if ($user->role === 'admin') {
            return Rental::with('user', 'vehicle')->paginate(15);
        }

        if ($user->role === 'rentalagent') {
            return Rental::with('user', 'vehicle')
                ->whereHas('vehicle', function ($q) use ($user) {
                    $q->where('rentalagent_id', $user->user_id);
                })
                ->get();
        }

        return Rental::where('user_id', $user->user_id)
            ->with('user', 'vehicle')
            ->paginate(15);
    }

    public function show($id)
    {
        $rental = Rental::with('user', 'vehicle', 'photos', 'review')->findOrFail($id);
        $this->authorize('view', $rental);
        return $rental;
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'vehicle_id' => 'required|exists:vehicles,vehicle_id',
            'start_date' => 'required|date_format:Y-m-d H:i:s',
            'end_date' => 'required|date_format:Y-m-d H:i:s|after:start_date',
            'pickup_location' => 'required|string|max:100',
            'return_location' => 'required|string|max:100',
        ]);

        $vehicle = \App\Models\Vehicle::findOrFail($validated['vehicle_id']);

        // Calculate total price
        $start = new \DateTime($validated['start_date']);
        $end = new \DateTime($validated['end_date']);
        $days = $start->diff($end)->days;
        $total_price = $days * $vehicle->daily_rate;

        $validated['user_id'] = auth()->id();
        $validated['total_price'] = $total_price;
        $validated['rental_status'] = 'pending_approval';

        $rental = Rental::create($validated);
        return response()->json($rental, 201);
    }

    public function update(Request $request, $id)
    {
        $rental = Rental::findOrFail($id);
        $this->authorize('update', $rental);

        $validated = $request->validate([
            'rental_status' => 'in:pending_approval,approved,rejected,in_progress,completed,cancelled',
            'actual_return_date' => 'nullable|date_format:Y-m-d H:i:s',
        ]);

        $rental->update($validated);
        return $rental;
    }

    public function destroy($id)
    {
        $rental = Rental::findOrFail($id);
        $this->authorize('delete', $rental);
        $rental->delete();

        return response()->noContent();
    }
}

