<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Models\ContactMessage;

class ContactMessageController extends Controller
{
    public function store(Request $request)
    {
        $validated = $request->validate([
            'first_name' => 'required|string|max:255',
            'last_name'  => 'required|string|max:255',
            'email'      => 'required|email|max:255',
            'message'    => 'required|string',
        ]);

        $msg = ContactMessage::create($validated);
        return response()->json($msg, 201);
    }

    public function index()
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user || $user->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }
        return response()->json(ContactMessage::orderBy('created_at', 'desc')->get());
    }

    public function markRead($id)
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user || $user->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }
        $msg = ContactMessage::findOrFail($id);
        $msg->update(['is_read' => true]);
        return response()->json($msg);
    }

    public function destroy($id)
    {
        $user = Auth::guard('sanctum')->user();
        if (!$user || $user->role !== 'admin') {
            return response()->json(['error' => 'Forbidden'], 403);
        }
        ContactMessage::findOrFail($id)->delete();
        return response()->json(['message' => 'Deleted']);
    }
}
