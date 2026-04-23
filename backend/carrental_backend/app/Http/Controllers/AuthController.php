<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use Illuminate\Support\Facades\Hash;

class AuthController extends Controller
{
    public function login(Request $request)
    {
        $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $user = User::where('email', $request->email)->first();

        if (!$user || !Hash::check($request->password, $user->password_hash)) {
            return response()->json([
                'message' => 'Hibás e-mail cím vagy jelszó.'
            ], 401);
        }

        $token = $user->createToken('auth-token')->plainTextToken;

        return response()->json([
            'message' => 'Sikeres bejelentkezés',
            'token' => $token,
            'user' => [
                'id' => $user->user_id,
                'first_name' => $user->first_name,
                'last_name' => $user->last_name,
                'email' => $user->email,
                'role' => $user->role,
            ]
        ]);
    }

    public function register(Request $request)
    {
        $validated = $request->validate([
            'first_name'             => 'required|string|max:255',
            'last_name'              => 'required|string|max:255',
            'username'               => 'required|string|max:255|unique:users,username',
            'email'                  => 'required|email|unique:users,email',
            'date_of_birth'          => 'required|date',
            'driving_license_number' => 'required|string|max:255',
            'password'               => 'required|string|min:6|confirmed',
        ]);

        $user = User::create([
            'first_name'             => $validated['first_name'],
            'last_name'              => $validated['last_name'],
            'username'               => $validated['username'],
            'email'                  => $validated['email'],
            'date_of_birth'          => $validated['date_of_birth'],
            'driving_license_number' => $validated['driving_license_number'],
            'password_hash'          => Hash::make($validated['password']),
            'role'                   => 'user',
            'user_status'            => 'active',
        ]);

        $token = $user->createToken('auth-token')->plainTextToken;

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
        ], 201);
    }
}
