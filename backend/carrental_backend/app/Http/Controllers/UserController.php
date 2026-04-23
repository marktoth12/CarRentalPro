<?php

namespace App\Http\Controllers;

use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class UserController extends Controller
{
    public function index()
    {
        $user = Auth::guard('sanctum')->user();

        if (!$user || $user->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        return response()->json(User::all());
    }

    public function store(Request $request)
    {
        return response()->json(['error' => 'Not implemented'], 501);
    }

    public function show(string $id)
    {
        $authUser = Auth::guard('sanctum')->user();

        if (!$authUser || ($authUser->role !== 'admin' && $authUser->user_id != $id)) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        return response()->json(User::findOrFail($id));
    }

    public function update(Request $request, string $id)
    {
        $authUser = Auth::guard('sanctum')->user();

        if (!$authUser || ($authUser->role !== 'admin' && $authUser->user_id != $id)) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $target = User::findOrFail($id);

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

    public function destroy(string $id)
    {
        $authUser = Auth::guard('sanctum')->user();

        if (!$authUser || $authUser->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        if ($authUser->user_id == $id) {
            return response()->json(['error' => 'Saját magadat nem törölheted.'], 422);
        }

        $target = User::findOrFail($id);
        $target->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
