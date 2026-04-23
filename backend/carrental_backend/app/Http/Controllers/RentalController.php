<?php

namespace App\Http\Controllers;

use App\Models\Rental;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RentalController extends Controller
{
    /**
     * Bérlések listázása
     * - Admin: mindent lát (paginalva)
     * - Rental Agent: csak a saját járműveire vonatkozó bérléseket látja
     * - Felhasználó: csak a saját bérléseit látja
     */
    public function index(Request $request)
    {
        $user = auth()->user();

        // Ha ?my=1 paraméter van, mindig csak a saját (bérlőként indított) bérlések
        if ($request->query('my')) {
            return Rental::where('user_id', $user->user_id)
                ->with('user', 'vehicle.images')
                ->get();
        }

        if ($user->role === 'admin') {
            // Admin látja az összes bérlést
            return Rental::with('user', 'vehicle.images')
                ->paginate(15);
        }

        if ($user->role === 'rentalagent') {
            // Rental Agent látja a saját járműveire vonatkozó bérléseket (agent dashboard-hoz)
            return Rental::with('user', 'vehicle.images')
                ->whereHas('vehicle', function ($q) use ($user) {
                    $q->where('rentalagent_id', $user->user_id);
                })
                ->get();
        }

        // Normál felhasználó: csak a saját bérlései
        return Rental::where('user_id', $user->user_id)
            ->with('user', 'vehicle.images')
            ->paginate(15);
    }

    /**
     * Egy konkrét bérlés részletes adatainak lekérése
     * Jogosultság ellenőrzéssel
     */
    public function show($id)
    {
        $user = auth()->user();

        // Teljes relációk betöltése
        $rental = Rental::with('user', 'vehicle', 'photos', 'review')->findOrFail($id);

        // Jogosultság ellenőrzés: ki nézheti meg ezt a bérlést?
        $canView = $user->role === 'admin'
            || $rental->user_id === $user->user_id
            || ($user->role === 'rentalagent' && $rental->vehicle && $rental->vehicle->rentalagent_id === $user->user_id);

        if (!$canView) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        return response()->json($rental);
    }

    /**
     * Új bérlés létrehozása (felhasználó részéről)
     */
    public function store(Request $request)
    {
        // 1. Validáció
        $validated = $request->validate([
            'vehicle_id'       => 'required|exists:vehicles,vehicle_id',
            'start_date'       => 'required|date_format:Y-m-d H:i:s',
            'end_date'         => 'required|date_format:Y-m-d H:i:s|after:start_date',
            'pickup_location'  => 'required|string|max:100',
            'return_location'  => 'required|string|max:100',
        ]);

        // 2. Jármű adatok lekérése az ár számításához
        $vehicle = \App\Models\Vehicle::findOrFail($validated['vehicle_id']);

        // 3. Összes bérlési nap kiszámítása és végösszeg számítása
        $start = new \DateTime($validated['start_date']);
        $end   = new \DateTime($validated['end_date']);
        $days  = $start->diff($end)->days;
        $total_price = $days * $vehicle->daily_rate;

        // 4. További adatok hozzáadása a bérléshez
        $validated['user_id']         = auth()->user()->user_id;
        $validated['total_price']     = $total_price;
        $validated['rental_status']   = 'pending_approval';   // alapállapot

        // 5. Bérlés mentése
        $rental = Rental::create($validated);

        return response()->json($rental, 201);
    }

    /**
     * Bérlés frissítése (státusz változtatás, stb.)
     * Jogosultság + üzleti logika (autó foglaltsága)
     */
    public function update(Request $request, $id)
    {
        $user = auth()->user();
        $rental = Rental::with('vehicle')->findOrFail($id);

        // Jogosultság ellenőrzés
        $canUpdate = $user->role === 'admin'
            || $rental->user_id === $user->user_id
            || ($user->role === 'rentalagent' && $rental->vehicle && $rental->vehicle->rentalagent_id === $user->user_id);

        if (!$canUpdate) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'rental_status'      => 'sometimes|in:pending_approval,approved,rejected,in_progress,completed,cancelled',
            'actual_return_date' => 'nullable|date_format:Y-m-d H:i:s',
        ]);

        $oldStatus = $rental->rental_status;
        $newStatus = $validated['rental_status'] ?? null;

        // === Üzleti logika: jármű foglaltsága ===

        // Jóváhagyáskor az autó foglalttá válik
        if ($newStatus === 'approved' && $oldStatus !== 'approved') {
            $validated['rentalagent_decision_date'] = now();
            \App\Models\Vehicle::where('vehicle_id', $rental->vehicle_id)
                ->update(['is_available' => false]);
        }

        // Elutasítás, lemondás vagy befejezés esetén az autó újra szabad
        if (in_array($newStatus, ['rejected', 'cancelled', 'completed']) &&
            !in_array($oldStatus, ['rejected', 'cancelled', 'completed'])) {

            $validated['rentalagent_decision_date'] = now();
            \App\Models\Vehicle::where('vehicle_id', $rental->vehicle_id)
                ->update(['is_available' => true]);
        }

        $rental->update($validated);
        return response()->json($rental->fresh());
    }

    /**
     * Bérlés törlése
     * Csak admin vagy a bérlő törölheti
     */
    public function destroy($id)
    {
        $user = auth()->user();
        $rental = Rental::with('vehicle')->findOrFail($id);

        $canDelete = $user->role === 'admin' || $rental->user_id === $user->user_id;

        if (!$canDelete) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $rental->delete();
        return response()->noContent(); // 204 No Content
    }
}
