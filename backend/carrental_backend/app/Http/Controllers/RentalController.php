<?php

namespace App\Http\Controllers;

use App\Models\Rental;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

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
        $user = auth()->user();
        $rental = Rental::with('user', 'vehicle', 'photos', 'review')->findOrFail($id);

        $canView = $user->role === 'admin'
            || $rental->user_id === $user->user_id
            || ($user->role === 'rentalagent' && $rental->vehicle && $rental->vehicle->rentalagent_id === $user->user_id);

        if (!$canView) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        return response()->json($rental);
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
        $user = auth()->user();
        $rental = Rental::with('vehicle')->findOrFail($id);

        // Jogosultság ellenőrzés: admin, a bérlő maga, vagy a jármű bérbeadója
        $canUpdate = $user->role === 'admin'
            || $rental->user_id === $user->user_id
            || ($user->role === 'rentalagent' && $rental->vehicle && $rental->vehicle->rentalagent_id === $user->user_id);

        if (!$canUpdate) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'rental_status' => 'sometimes|in:pending_approval,approved,rejected,in_progress,completed,cancelled',
            'actual_return_date' => 'nullable|date_format:Y-m-d H:i:s',
        ]);

        $oldStatus = $rental->rental_status;
        $newStatus = $validated['rental_status'] ?? null;

        // Jóváhagyáskor: az autó legyen foglalt az adatbázisban
        if ($newStatus === 'approved' && $oldStatus !== 'approved') {
            $validated['rentalagent_decision_date'] = now();
            \App\Models\Vehicle::where('vehicle_id', $rental->vehicle_id)
                ->update(['is_available' => false]);
        }

        // Elutasítás / lemondás / befejezéskor: az autó újra szabad legyen
        if (in_array($newStatus, ['rejected', 'cancelled', 'completed']) &&
            !in_array($oldStatus, ['rejected', 'cancelled', 'completed'])) {
            $validated['rentalagent_decision_date'] = now();
            \App\Models\Vehicle::where('vehicle_id', $rental->vehicle_id)
                ->update(['is_available' => true]);
        }

        $rental->update($validated);
        return response()->json($rental->fresh());
    }

    public function destroy($id)
    {
        $user = auth()->user();
        $rental = Rental::with('vehicle')->findOrFail($id);

        $canDelete = $user->role === 'admin'
            || $rental->user_id === $user->user_id;

        if (!$canDelete) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $rental->delete();
        return response()->noContent();
    }
}
