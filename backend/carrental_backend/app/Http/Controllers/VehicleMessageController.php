<?php

namespace App\Http\Controllers;

use App\Models\VehicleMessage;
use App\Models\Vehicle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VehicleMessageController extends Controller
{
    // User üzenetet küld egy járműhöz
    public function store(Request $request)
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        $validated = $request->validate([
            'vehicle_id' => 'required|exists:vehicles,vehicle_id',
            'message'    => 'required|string|max:1000',
        ]);

        $vehicle = Vehicle::findOrFail($validated['vehicle_id']);

        $msg = VehicleMessage::create([
            'vehicle_id'    => $validated['vehicle_id'],
            'sender_id'     => $user->user_id,
            'rentalagent_id'=> $vehicle->rentalagent_id,
            'message'       => $validated['message'],
        ]);

        return response()->json($msg->load('sender'), 201);
    }

    // Agent lekéri a saját üzeneteit
    public function index()
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

        if ($user->role === 'rentalagent') {
            return response()->json(
                VehicleMessage::where('rentalagent_id', $user->user_id)
                    ->with('sender', 'vehicle')
                    ->orderBy('created_at', 'desc')
                    ->get()
            );
        }

        return response()->json(['error' => 'Forbidden'], 403);
    }

    // Olvasottnak jelölés
    public function markRead($id)
    {
        $user = Auth::guard('sanctum')->user();
        $msg = VehicleMessage::findOrFail($id);

        if ($msg->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $msg->update(['is_read' => true]);
        return response()->json($msg);
    }

    // Törlés
    public function destroy($id)
    {
        $user = Auth::guard('sanctum')->user();
        $msg = VehicleMessage::findOrFail($id);

        if ($msg->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $msg->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
