<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class VehicleImage extends Model
{
    use HasFactory;   // Gyári adatok generálásához (tesztek, seeder)

    /**
     * Az adatbázis tábla neve
     */
    protected $table = 'vehicle_images';

    /**
     * Egyedi elsődleges kulcs
     */
    protected $primaryKey = 'image_id';

    /**
     * Mass assignmentt
     */
    protected $fillable = [
        'vehicle_id',     // melyik járműhöz tartozik
        'image_url',      // a kép elérési útja / URL-je
        'description',    // opcionális leírás
    ];

    /**
     * RELÁCIÓK
     */

    /**
     * A képhez tartozó jármű
     */
    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class, 'vehicle_id', 'vehicle_id');
    }
}
