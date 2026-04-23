<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    /**
     * Bejelentkezés (Login)
     */
    public function login(Request $request)
    {
        // 1. Bejövő adatok validálása
        $request->validate([
            'email'    => 'required|email',
            'password' => 'required',
        ]);

        // 2. Felhasználó keresése email cím alapján
        $user = User::where('email', $request->email)->first();

        // 3. Felhasználó ellenőrzése és jelszó ellenőrzés
        if (!$user || !Hash::check($request->password, $user->password_hash)) {
            return response()->json([
                'message' => 'Hibás e-mail cím vagy jelszó.'
            ], 401);
        }

        // 4. Token generálása (Sanctum)
        $token = $user->createToken('auth-token')->plainTextToken;

        // 5. Sikeres válasz visszaadása
        return response()->json([
            'message' => 'Sikeres bejelentkezés',
            'token'   => $token,
            'user'    => [
                'id'         => $user->user_id,
                'first_name' => $user->first_name,
                'last_name'  => $user->last_name,
                'email'      => $user->email,
                'role'       => $user->role,
            ]
        ]);
    }

    /**
     * Regisztráció (Register)
     */
    public function register(Request $request)
    {
        // 1. Bejövő adatok validálása
        $validated = $request->validate([
            'first_name'            => 'required|string|max:255',
            'last_name'             => 'required|string|max:255',
            'username'              => 'required|string|max:255|unique:users,username',
            'email'                 => 'required|email|unique:users,email',
            'date_of_birth'         => 'required|date',
            'driving_license_number'=> 'required|string|max:255',
            'password'              => 'required|string|min:6|confirmed',
        ]);

        // 2. Új felhasználó létrehozása az adatbázisban
        $user = User::create([
            'first_name'            => $validated['first_name'],
            'last_name'             => $validated['last_name'],
            'username'              => $validated['username'],
            'email'                 => $validated['email'],
            'date_of_birth'         => $validated['date_of_birth'],
            'driving_license_number'=> $validated['driving_license_number'],
            'password_hash'         => Hash::make($validated['password']), // jelszó hashelése
            'role'                  => 'user',          // alapértelmezett szerepkör
            'user_status'           => 'active',        // alapértelmezett státusz
        ]);

        // 3. Token generálása az új felhasználónak
        $token = $user->createToken('auth-token')->plainTextToken;

        // 4. Sikeres válasz visszaadása
        return response()->json([
            'message' => 'Sikeres regisztráció',
            'token'   => $token,
            'user'    => [
                'id'         => $user->user_id,
                'first_name' => $user->first_name,
                'last_name'  => $user->last_name,
                'email'      => $user->email,
                'role'       => $user->role,
            ]
        ], 201); // 201 = Created
    }
}
