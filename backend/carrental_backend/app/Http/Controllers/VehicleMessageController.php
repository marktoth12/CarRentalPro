<?php

namespace App\Http\Controllers;

use App\Models\VehicleMessage;
use App\Models\Vehicle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VehicleMessageController extends Controller
{
    /**
     * Új üzenet küldése egy járműhöz (felhasználó részéről)
     */
    public function store(Request $request)
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        // 1. Validáció
        $validated = $request->validate([
            'vehicle_id' => 'required|exists:vehicles,vehicle_id',
            'message'    => 'required|string|max:1000',
        ]);

        // 2. Jármű lekérése a rentalagent_id miatt
        $vehicle = Vehicle::findOrFail($validated['vehicle_id']);

        // 3. Üzenet létrehozása
        $msg = VehicleMessage::create([
            'vehicle_id'     => $validated['vehicle_id'],
            'sender_id'      => $user->user_id,
            'rentalagent_id' => $vehicle->rentalagent_id,   // kinek szól az üzenet
            'message'        => $validated['message'],
        ]);

        // 4. Válasz a feladó adataival együtt
        return response()->json($msg->load('sender'), 201);
    }

    /**
     * Üzenetek lekérése
     * Jelenleg csak rental agent használhatja (saját beérkező üzenetei)
     */
    public function index()
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        if ($user->role === 'rentalagent') {
            return response()->json(
                VehicleMessage::where('rentalagent_id', $user->user_id)
                    ->with('sender', 'vehicle')           // feladó és jármű adatok
                    ->orderBy('created_at', 'desc')
                    ->get()
            );
        }

        return response()->json(['error' => 'Forbidden'], 403);
    }

    /**
     * Üzenet megjelölése olvasottként
     */
    public function markRead($id)
    {
        $user = Auth::guard('sanctum')->user();
        $msg = VehicleMessage::findOrFail($id);

        // Csak a címzett rental agent jelölheti olvasottnak
        if ($msg->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $msg->update(['is_read' => true]);

        return response()->json($msg);
    }

    /**
     * Üzenet törlése
     */
    public function destroy($id)
    {
        $user = Auth::guard('sanctum')->user();
        $msg = VehicleMessage::findOrFail($id);

        // Csak a címzett rental agent törölheti
        if ($msg->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $msg->delete();

        return response()->json(['message' => 'Deleted']);
    }
}
