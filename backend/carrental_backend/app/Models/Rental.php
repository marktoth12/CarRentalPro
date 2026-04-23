<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Rental extends Model
{
    use HasFactory;   // Gyári adatok generálásához (tesztekhez, seeder-hez)

    /**
     * Az adatbázis tábla neve
     */
    protected $table = 'rentals';

    /**
     * Elsődleges kulcs (nem a hagyományos 'id')
     */
    protected $primaryKey = 'rental_id';

    /**
     * Mass assignment ellen védett mezők
     */
    protected $fillable = [
        'user_id',
        'vehicle_id',
        'start_date',
        'end_date',
        'actual_return_date',
        'pickup_location',
        'return_location',
        'total_price',
        'rental_status',
        'rentalagent_decision_date',
    ];

    /**
     * Automatikus típuskonverziók
     */
    protected $casts = [
        'start_date'               => 'datetime',
        'end_date'                 => 'datetime',
        'actual_return_date'       => 'datetime',
        'rental_request_date'      => 'datetime',   // ha létezik a mező
        'rentalagent_decision_date'=> 'datetime',
    ];

    /**
     * RELÁCIÓK
     */

    /**
     * A bérlő felhasználó
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    /**
     * A kibérelt jármű
     */
    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class, 'vehicle_id', 'vehicle_id');
    }

    /**
     * A bérléshez tartozó fotók (pickup, return, damage stb.)
     */
    public function photos()
    {
        return $this->hasMany(RentalPhoto::class, 'rental_id', 'rental_id');
    }
}
