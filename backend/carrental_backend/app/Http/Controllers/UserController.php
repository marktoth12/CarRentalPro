<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    /**
     * Felhasználók listázása
     * (Csak admin jogosultsággal)
     */
    public function index()
    {
        $user = Auth::guard('sanctum')->user();

        if (!$user || $user->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        // Minden felhasználó visszaadása
        return response()->json(User::all());
    }

    /**
     * Új felhasználó létrehozása
     * (Jelenleg nincs implementálva)
     */
    public function store(Request $request)
    {
        return response()->json(['error' => 'Not implemented'], 501);
    }

    /**
     * Egy konkrét felhasználó adatainak lekérése
     * - Admin: bármelyik felhasználót láthat
     * - Felhasználó: csak a saját profilját láthatja
     */
    public function show(string $id)
    {
        $authUser = Auth::guard('sanctum')->user();

        // Jogosultság ellenőrzés
        if (!$authUser || ($authUser->role !== 'admin' && $authUser->user_id != $id)) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        return response()->json(User::findOrFail($id));
    }

    /**
     * Felhasználó adatainak frissítése
     * - Saját profil szerkesztése
     * - Admin bármelyik felhasználót szerkesztheti
     */
    public function update(Request $request, string $id)
    {
        $authUser = Auth::guard('sanctum')->user();

        // Jogosultság ellenőrzés
        if (!$authUser || ($authUser->role !== 'admin' && $authUser->user_id != $id)) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $target = User::findOrFail($id);

        // Validáció
        $validated = $request->validate([
            'first_name'  => 'sometimes|string|max:255',
            'last_name'   => 'sometimes|string|max:255',
            'email'       => 'sometimes|email|unique:users,email,' . $id . ',user_id',
            'role'        => 'sometimes|in:admin,rentalagent,user',
            'user_status' => 'sometimes|in:active,inactive,suspended',
        ]);

        $target->update($validated);

        return response()->json($target);
    }

    /**
     * Felhasználó törlése
     * (Csak admin jogosultsággal, saját magát nem törölheti)
     */
    public function destroy(string $id)
    {
        $authUser = Auth::guard('sanctum')->user();

        // Csak admin törölhet
        if (!$authUser || $authUser->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        // Saját magát nem törölheti
        if ($authUser->user_id == $id) {
            return response()->json([
                'error' => 'Saját magadat nem törölheted.'
            ], 422);
        }

        $target = User::findOrFail($id);
        $target->delete();

        return response()->json(['message' => 'Deleted']);
    }
}
