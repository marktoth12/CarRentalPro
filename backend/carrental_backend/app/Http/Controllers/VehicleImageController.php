<?php

namespace App\Http\Controllers;

use App\Models\VehicleImage;
use App\Models\Vehicle;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;

class VehicleImageController extends Controller
{
    /**
     * Járműképek listázása
     */
    public function index(Request $request)
    {
        $vehicleId = $request->query('vehicle_id');

        // Ha meg van adva vehicle_id, csak annak a képeit adjuk vissza
        if ($vehicleId) {
            return response()->json(
                VehicleImage::where('vehicle_id', $vehicleId)->get()
            );
        }

        // Egyébként az összes képet (általában nem ajánlott, csak adminoknak)
        return response()->json(VehicleImage::all());
    }

    /**
     * Új kép feltöltése egy járműhöz
     */
    public function store(Request $request)
    {
        $user = Auth::guard('sanctum')->user();

        // 1. Validáció
        $validated = $request->validate([
            'vehicle_id'  => 'required|exists:vehicles,vehicle_id',
            'image_url'   => 'required|url|max:255',
            'description' => 'nullable|string|max:255',
        ]);

        // 2. Jogosultság ellenőrzés: csak a jármű tulajdonosa (rentalagent) vagy admin
        $vehicle = Vehicle::findOrFail($validated['vehicle_id']);
        if ($user->role !== 'admin' && $vehicle->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        // 3. Maximum 5 kép ellenőrzése járművenként
        $count = VehicleImage::where('vehicle_id', $validated['vehicle_id'])->count();
        if ($count >= 5) {
            return response()->json([
                'error' => 'Egy járműhöz maximum 5 kép adható meg.'
            ], 422);
        }

        // 4. Kép mentése
        $image = VehicleImage::create($validated);

        return response()->json($image, 201); // 201 = Created
    }

    /**
     * Egy konkrét kép adatainak lekérése
     */
    public function show($id)
    {
        return response()->json(VehicleImage::findOrFail($id));
    }

    /**
     * Kép adatainak módosítása (pl. leírás vagy URL)
     */
    public function update(Request $request, $id)
    {
        $user = Auth::guard('sanctum')->user();
        $image = VehicleImage::findOrFail($id);
        $vehicle = Vehicle::findOrFail($image->vehicle_id);

        // Jogosultság ellenőrzés
        if ($user->role !== 'admin' && $vehicle->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $validated = $request->validate([
            'image_url'   => 'sometimes|url|max:255',
            'description' => 'nullable|string|max:255',
        ]);

        $image->update($validated);

        return response()->json($image);
    }

    /**
     * Kép törlése
     */
    public function destroy($id)
    {
        $user = Auth::guard('sanctum')->user();
        $image = VehicleImage::findOrFail($id);
        $vehicle = Vehicle::findOrFail($image->vehicle_id);

        // Jogosultság ellenőrzés
        if ($user->role !== 'admin' && $vehicle->rentalagent_id !== $user->user_id) {
            return response()->json(['error' => 'Forbidden'], 403);
        }

        $image->delete();

        return response()->json(['message' => 'Deleted']);
    }
}
