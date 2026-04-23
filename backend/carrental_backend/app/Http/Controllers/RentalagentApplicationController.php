<?php

namespace App\Http\Controllers;

use App\Models\RentalagentApplication;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RentalagentApplicationController extends Controller
{
    /**
     * Jelentkezések listázása
     * - Admin: látja az összes jelentkezést
     * - Felhasználó: csak a saját jelentkezéseit látja
     */
    public function index()
    {
        $user = Auth::guard('sanctum')->user();

        if ($user->role === 'admin') {
            // Admin látja az összes jelentkezést (user és admin relációkkal)
            return response()->json(
                RentalagentApplication::with('user', 'admin')->get()
            );
        }

        // Normál felhasználó csak a saját jelentkezéseit kapja
        return response()->json(
            RentalagentApplication::where('user_id', $user->user_id)
                ->with('user', 'admin')
                ->get()
        );
    }

    /**
     * Egy konkrét jelentkezés részletes adatainak lekérése
     */
    public function show($id)
    {
        // findOrFail automatikusan 404-et dob, ha nem található
        $application = RentalagentApplication::with('user', 'admin')->findOrFail($id);
        return response()->json($application);
    }

    /**
     * Új rental agent jelentkezés létrehozása (felhasználó részéről)
     */
    public function store(Request $request)
    {
        $user = Auth::guard('sanctum')->user();

        // Ellenőrizzük, hogy van-e már függőben lévő jelentkezése
        $existing = RentalagentApplication::where('user_id', $user->user_id)->first();
        if ($existing) {
            return response()->json([
                'message' => 'Már van folyamatban lévő jelentkezésed!'
            ], 422);
        }

        // Új jelentkezés létrehozása
        $application = RentalagentApplication::create([
            'user_id' => $user->user_id,
            'status'  => 'pending',        // alapállapot
        ]);

        return response()->json($application, 201); // 201 = Created
    }

    /**
     * Jelentkezés jóváhagyása (csak admin)
     */
    public function approve(Request $request, $id)
    {
        $admin = Auth::guard('sanctum')->user();

        // Jogosultság ellenőrzés
        if ($admin->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Jelentkezés frissítése
        $application = RentalagentApplication::findOrFail($id);
        $application->update([
            'status'        => 'approved',
            'admin_id'      => $admin->user_id,
            'decision_date' => now(),
        ]);

        // Felhasználó szerepkörének frissítése rental agent-re
        $user = $application->user;
        $user->role = 'rentalagent';
        $user->save();

        return response()->json($application);
    }

    /**
     * Jelentkezés elutasítása (csak admin)
     */
    public function reject(Request $request, $id)
    {
        $admin = Auth::guard('sanctum')->user();

        // Jogosultság ellenőrzés
        if ($admin->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        // Jelentkezés frissítése
        $application = RentalagentApplication::findOrFail($id);
        $application->update([
            'status'        => 'rejected',
            'admin_id'      => $admin->user_id,
            'decision_date' => now(),
        ]);

        return response()->json($application);
    }
}
