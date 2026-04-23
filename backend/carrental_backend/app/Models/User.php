<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;
use Laravel\Sanctum\HasApiTokens;

class User extends Authenticatable
{
    /**
     * Laravel Auth + API + Notification + Factory támogatások
     */
    use HasApiTokens,      // Sanctum tokenekhez (API autentikáció)
        HasFactory,        // Tesztekhez és seeder-hez
        Notifiable;        // Értesítések küldéséhez (mail, database, stb.)

    /**
     * Az adatbázis tábla neve
     */
    protected $table = 'users';

    /**
     * Egyedi elsődleges kulcs (nem az alap 'id')
     */
    protected $primaryKey = 'user_id';

    /**
     * Mass assignment
     */
    protected $fillable = [
        'username',
        'email',
        'password_hash',
        'first_name',
        'last_name',
        'date_of_birth',
        'driving_license_number',
        'driving_license_front_image_url',
        'driving_license_back_image_url',
        'is_approved',
        'user_status',
        'role',
    ];

    protected $hidden = [
        'password_hash',     // jelszó hash
        'remember_token',    // "emlékezz rám" token
    ];

    /**
     * Egyedi metódus a Laravel autentikációhoz
     * (mert a jelszó mező neve password_hash, nem password)
     */
    public function getAuthPassword()
    {
        return $this->password_hash;
    }

    /**
     * Automatikus típuskonverziók
     */
    protected function casts(): array
    {
        return [
            'registration_date' => 'datetime',
            'date_of_birth'     => 'date',        // csak dátum, nem idő
            'is_approved'       => 'boolean',
        ];
    }

    /**
     * RELÁCIÓK
     */

    /**
     * A járművek, amiket ez a felhasználó (rental agentként) hirdet
     */
    public function vehicles()
    {
        return $this->hasMany(Vehicle::class, 'rentalagent_id', 'user_id');
    }

    /**
     * A felhasználó által létrehozott bérlések (mint bérlő)
     */
    public function rentals()
    {
        return $this->hasMany(Rental::class, 'user_id', 'user_id');
    }

    /**
     * Rental Agent jelentkezések (ha próbál rental agent lenni)
     */
    public function applications()
    {
        return $this->hasMany(RentalagentApplication::class, 'user_id', 'user_id');
    }
}
