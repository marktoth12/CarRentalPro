<?php

namespace App\Http\Controllers;

use App\Models\RentalPhoto;
use Illuminate\Http\Request;

class RentalPhotoController extends Controller
{
    public function index(Request $request)
    {
        return RentalPhoto::where('rental_id', $request->query('rental_id'))->paginate(15);
    }

    public function show($id)
    {
        return RentalPhoto::findOrFail($id);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'rental_id' => 'required|exists:rentals,rental_id',
            'image_url' => 'required|string|max:255',
            'photo_type' => 'required|in:pickup_user,pickup_rentalagent,return_user,return_rentalagent,damage_report',
        ]);

        $validated['uploader_user_id'] = auth()->id();
        $photo = RentalPhoto::create($validated);

        return response()->json($photo, 201);
    }

    public function destroy($id)
    {
        $photo = RentalPhoto::findOrFail($id);
        $photo->delete();

        return response()->noContent();
    }
}

