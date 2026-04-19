<?php

namespace App\Http\Controllers;

use App\Models\RentalagentApplication;
use Illuminate\Http\Request;

class RentalagentApplicationController extends Controller
{
    public function index()
    {
        $user = auth()->user();

        if ($user->role === 'admin') {
            return RentalagentApplication::with('user', 'admin')->paginate(15);
        }

        return RentalagentApplication::where('user_id', $user->user_id)->with('user', 'admin')->paginate(15);
    }

    public function show($id)
    {
        $application = RentalagentApplication::with('user', 'admin')->findOrFail($id);
        return $application;
    }

    public function store(Request $request)
    {
        $user = auth()->user();

        // Check if user already has an application
        $existing = RentalagentApplication::where('user_id', $user->user_id)->first();
        if ($existing) {
            return response()->json(['message' => 'You already have an application'], 422);
        }

        $application = RentalagentApplication::create([
            'user_id' => $user->user_id,
            'status' => 'pending',
        ]);

        return response()->json($application, 201);
    }

    public function approve(Request $request, $id)
    {
        $this->authorize('create', RentalagentApplication::class);

        $application = RentalagentApplication::findOrFail($id);

        $application->update([
            'status' => 'approved',
            'admin_id' => auth()->id(),
            'decision_date' => now(),
        ]);

        // Update user role
        $user = $application->user;
        $user->update(['role' => 'rentalagent']);

        return $application;
    }

    public function reject(Request $request, $id)
    {
        $this->authorize('create', RentalagentApplication::class);

        $application = RentalagentApplication::findOrFail($id);

        $application->update([
            'status' => 'rejected',
            'admin_id' => auth()->id(),
            'decision_date' => now(),
        ]);

        return $application;
    }
}

