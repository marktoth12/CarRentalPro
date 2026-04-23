<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VehicleMessage extends Model
{
    /**
     * Az adatbázis tábla neve
     */
    protected $table = 'vehicle_messages';

    /**
     * Mass assignment
     */
    protected $fillable = [
        'vehicle_id',       // melyik járműhöz érkezett az üzenet
        'sender_id',        // ki küldte az üzenetet (felhasználó)
        'rentalagent_id',   // kinek szól az üzenet (a jármű tulajdonosa)
        'message',          // az üzenet szövege
        'is_read',          // olvasott-e
    ];

    /**
     * Automatikus típuskonverziók
     */
    protected $casts = [
        'is_read' => 'boolean',
    ];

    /**
     * RELÁCIÓK
     */

    /**
     * Az üzenet küldője (felhasználó)
     */
    public function sender()
    {
        return $this->belongsTo(User::class, 'sender_id', 'user_id');
    }

    /**
     * A jármű, amelyre az üzenet vonatkozik
     */
    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class, 'vehicle_id', 'vehicle_id');
    }
}
