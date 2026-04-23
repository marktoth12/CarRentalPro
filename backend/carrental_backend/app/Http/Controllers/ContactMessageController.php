<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\ContactMessage;

class ContactMessageController extends Controller
{
    /**
     * Új kapcsolatfelvételi üzenet tárolása (külső felhasználók számára)
     */
    public function store(Request $request)
    {
        // 1. Bejövő adatok validálása
        $validated = $request->validate([
            'first_name' => 'required|string|max:255',
            'last_name'  => 'required|string|max:255',
            'email'      => 'required|email|max:255',
            'message'    => 'required|string',
        ]);

        // 2. Üzenet mentése az adatbázisba
        $msg = ContactMessage::create($validated);

        // 3. Sikeres válasz visszaadása
        return response()->json($msg, 201); // 201 = Created
    }

    /**
     * Összes üzenet lekérdezése (csak adminoknak)
     */
    public function index()
    {
        // 1. Auth ellenőrzés + jogosultság vizsgálat
        $user = Auth::guard('sanctum')->user();
        if (!$user || $user->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        // 2. Üzenetek lekérése (legújabb elől)
        return response()->json(
            ContactMessage::orderBy('created_at', 'desc')->get()
        );
    }

    /**
     * Üzenet megjelölése olvasottként (csak adminoknak)
     */
    public function markRead($id)
    {
        // 1. Auth ellenőrzés + jogosultság vizsgálat
        $user = Auth::guard('sanctum')->user();
        if (!$user || $user->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        // 2. Üzenet keresése és frissítése
        $msg = ContactMessage::findOrFail($id);
        $msg->update(['is_read' => true]);

        // 3. Frissített üzenet visszaadása
        return response()->json($msg);
    }

    /**
     * Üzenet törlése (csak adminoknak)
     */
    public function destroy($id)
    {
        // 1. Auth ellenőrzés + jogosultság vizsgálat
        $user = Auth::guard('sanctum')->user();
        if (!$user || $user->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        // 2. Üzenet keresése és törlése
        ContactMessage::findOrFail($id)->delete();

        // 3. Sikeres törlés visszaigazolása
        return response()->json(['message' => 'Deleted']);
    }
}
