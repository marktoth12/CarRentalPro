<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Vehicle extends Model
{
    use HasFactory;   // Gyári adatok generálásához (tesztek, seeder)

    /**
     * Az adatbázis tábla neve
     */
    protected $table = 'vehicles';

    /**
     * Egyedi elsődleges kulcs
     */
    protected $primaryKey = 'vehicle_id';

    /**
     * Időpontok (created_at, updated_at) engedélyezése
     * (Ha az adatbázisban léteznek ezek az oszlopok)
     */
    public $timestamps = true;

    /**
     * Mass assignment
     */
    protected $fillable = [
        'rentalagent_id',       // a jármű tulajdonosa (rental agent)
        'brand',
        'model',
        'year',
        'license_plate',        // rendszám
        'daily_rate',           // napi bérleti díj
        'description',
        'fuel_type',
        'transmission_type',
        'number_of_seats',
        'location_pickup',
        'location_return',
        'is_available',         // elérhető-e bérlésre
        'is_approved',          // admin jóváhagyta-e
    ];

    /**
     * Automatikus típuskonverziók
     */
    protected $casts = [
        'is_available' => 'boolean',
        'is_approved'  => 'boolean',
    ];

    /**
     * RELÁCIÓK
     */

    /**
     * A jármű tulajdonosa (Rental Agent)
     */
    public function rentalAgent()
    {
        return $this->belongsTo(User::class, 'rentalagent_id', 'user_id');
    }

    /**
     * A járműhöz tartozó képek
     */
    public function images()
    {
        return $this->hasMany(VehicleImage::class, 'vehicle_id', 'vehicle_id');
    }

    /**
     * A járműhöz tartozó bérlések
     */
    public function rentals()
    {
        return $this->hasMany(\App\Models\Rental::class, 'vehicle_id', 'vehicle_id');
    }
}
