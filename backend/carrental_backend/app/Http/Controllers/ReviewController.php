<?php

namespace App\Http\Controllers;

use App\Models\Review;
use Illuminate\Http\Request;

class ReviewController extends Controller
{
    public function index()
    {
        return Review::with('rental', 'reviewer', 'reviewed')->paginate(15);
    }

    public function show($id)
    {
        return Review::with('rental', 'reviewer', 'reviewed')->findOrFail($id);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'rental_id' => 'required|exists:rentals,rental_id|unique:reviews',
            'reviewed_user_id' => 'required|exists:users,user_id',
            'rating' => 'required|integer|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        $validated['reviewer_user_id'] = auth()->id();
        $review = Review::create($validated);

        return response()->json($review, 201);
    }

    public function update(Request $request, $id)
    {
        $review = Review::findOrFail($id);
        $this->authorize('update', $review);

        $validated = $request->validate([
            'rating' => 'integer|min:1|max:5',
            'comment' => 'nullable|string',
        ]);

        $review->update($validated);
        return $review;
    }

    public function destroy($id)
    {
        $review = Review::findOrFail($id);
        $this->authorize('delete', $review);
        $review->delete();

        return response()->noContent();
    }
}

