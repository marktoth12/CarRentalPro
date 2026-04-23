<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class RentalagentApplication extends Model
{
    use HasFactory;   // Gyári adatok generálásához (tesztek, seeder)

    /**
     * Az adatbázis tábla neve
     */
    protected $table = 'rentalagent_applications';

    /**
     * Elsődleges kulcs (nem a hagyományos 'id')
     */
    protected $primaryKey = 'application_id';

    /**
     * Mass assignment
     */
    protected $fillable = [
        'user_id',          // aki jelentkezett
        'status',           // pending / approved / rejected
        'admin_id',         // melyik admin döntött
        'decision_date',    // döntés dátuma
    ];

    /**
     * Automatikus típuskonverziók
     */
    protected $casts = [
        'application_date' => 'datetime',   // amikor a felhasználó jelentkezett
        'decision_date'    => 'datetime',   // amikor az admin jóváhagyta/elutasította
    ];

    /**
     * RELÁCIÓK
     */

    /**
     * A jelentkező felhasználó
     */
    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    /**
     * Az admin, aki jóváhagyta vagy elutasította a jelentkezést
     * (null lehet, amíg nincs döntés)
     */
    public function admin()
    {
        return $this->belongsTo(User::class, 'admin_id', 'user_id');
    }
}
