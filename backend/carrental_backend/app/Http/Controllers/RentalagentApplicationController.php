<?php

namespace App\Http\Controllers;

use App\Models\RentalagentApplication;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class RentalagentApplicationController extends Controller
{
    public function index()
    {
        $user = Auth::guard('sanctum')->user();

        if ($user->role === 'admin') {
            // .get() használata paginate helyett, ha a Vue egyszerű tömböt vár
            return response()->json(RentalagentApplication::with('user', 'admin')->get());
        }

        return response()->json(
            RentalagentApplication::where('user_id', $user->user_id)
                ->with('user', 'admin')
                ->get()
        );
    }

    public function show($id)
    {
        $application = RentalagentApplication::with('user', 'admin')->findOrFail($id);
        return response()->json($application);
    }

    public function store(Request $request)
    {
        $user = Auth::guard('sanctum')->user();

        $existing = RentalagentApplication::where('user_id', $user->user_id)->first();
        if ($existing) {
            return response()->json(['message' => 'Már van folyamatban lévő jelentkezésed!'], 422);
        }

        $application = RentalagentApplication::create([
            'user_id' => $user->user_id,
            'status' => 'pending',
        ]);

        return response()->json($application, 201);
    }

    public function approve(Request $request, $id)
    {
        $admin = Auth::guard('sanctum')->user();
        if ($admin->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $application = RentalagentApplication::findOrFail($id);
        $application->update([
            'status' => 'approved',
            'admin_id' => $admin->user_id,
            'decision_date' => now(),
        ]);

        $user = $application->user;
        $user->role = 'rentalagent';
        $user->save();

        return response()->json($application);
    }

    public function reject(Request $request, $id)
    {
        $admin = Auth::guard('sanctum')->user();
        if ($admin->role !== 'admin') {
            return response()->json(['message' => 'Unauthorized'], 403);
        }

        $application = RentalagentApplication::findOrFail($id);
        $application->update([
            'status' => 'rejected',
            'admin_id' => $admin->user_id,
            'decision_date' => now(),
        ]);

        return response()->json($application);
    }
}
