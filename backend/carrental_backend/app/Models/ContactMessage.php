<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class ContactMessage extends Model
{
    /**
     * Az adatbázis tábla neve
     * (Ha nem követi a Laravel konvenciót: contact_messages)
     */
    protected $table = 'contact_messages';

    /**
     * Mass assignment (tömeges feltöltés) engedélyezett mezői
     */
    protected $fillable = [
        'first_name',
        'last_name',
        'email',
        'message',
        'is_read',
    ];

    /**
     * Automatikus típuskonverzió
     * Az adatbázisból érkező értékeket Laravel átkonvertálja a megadott típusra
     */
    protected $casts = [
        'is_read' => 'boolean',     // boolean-ként kezeljük (true/false)
    ];
}
