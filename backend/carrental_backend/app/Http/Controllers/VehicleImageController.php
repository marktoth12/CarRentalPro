<?php

namespace App\Http\Controllers;

use App\Models\VehicleImage;
use Illuminate\Http\Request;

class VehicleImageController extends Controller
{
    public function index(Request $request)
    {
        return VehicleImage::where('vehicle_id', $request->query('vehicle_id'))->paginate(15);
    }

    public function show($id)
    {
        return VehicleImage::findOrFail($id);
    }

    public function store(Request $request)
    {
        $validated = $request->validate([
            'vehicle_id' => 'required|exists:vehicles,vehicle_id',
            'image_url' => 'required|string|max:255',
            'description' => 'nullable|string|max:255',
        ]);

        $image = VehicleImage::create($validated);
        return response()->json($image, 201);
    }

    public function update(Request $request, $id)
    {
        $image = VehicleImage::findOrFail($id);

        $validated = $request->validate([
            'image_url' => 'string|max:255',
            'description' => 'nullable|string|max:255',
        ]);

        $image->update($validated);
        return $image;
    }

    public function destroy($id)
    {
        $image = VehicleImage::findOrFail($id);
        $image->delete();

        return response()->noContent();
    }
}

