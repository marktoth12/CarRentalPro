<?php

namespace App\Http\Controllers;

use App\Models\RentalPhoto;
use Illuminate\Http\Request;

class RentalPhotoController extends Controller
{
    /**
     * Bérléshez tartozó fotók listázása
     * (Query paraméter alapján: ?rental_id=123)
     */
    public function index(Request $request)
    {
        // Csak egy konkrét bérlés fotóit adjuk vissza, paginálva
        return RentalPhoto::where('rental_id', $request->query('rental_id'))
            ->paginate(15);
    }

    /**
     * Egy konkrét fotó adatainak lekérése
     */
    public function show($id)
    {
        // findOrFail automatikusan 404-es választ ad, ha nem létezik
        return RentalPhoto::findOrFail($id);
    }

    /**
     * Új fotó feltöltése egy bérléshez
     */
    public function store(Request $request)
    {
        // 1. Bejövő adatok validálása
        $validated = $request->validate([
            'rental_id'   => 'required|exists:rentals,rental_id',
            'image_url'   => 'required|string|max:255',
            'photo_type'  => 'required|in:pickup_user,pickup_rentalagent,return_user,return_rentalagent,damage_report',
        ]);

        // 2. Feltöltő felhasználó ID hozzáadása
        $validated['uploader_user_id'] = auth()->id();

        // 3. Fotó mentése az adatbázisba
        $photo = RentalPhoto::create($validated);

        // 4. Sikeres válasz
        return response()->json($photo, 201); // 201 = Created
    }

    /**
     * Fotó törlése
     */
    public function destroy($id)
    {
        // 1. Fotó keresése
        $photo = RentalPhoto::findOrFail($id);

        // 2. Törlés
        $photo->delete();

        // 3. Válasz 204 No Content státusszal
        return response()->noContent();
    }
}
