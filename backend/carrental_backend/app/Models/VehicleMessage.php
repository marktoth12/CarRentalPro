<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class VehicleMessage extends Model
{
    protected $table = 'vehicle_messages';

    protected $fillable = [
        'vehicle_id',
        'sender_id',
        'rentalagent_id',
        'message',
        'is_read',
    ];

    protected $casts = [
        'is_read' => 'boolean',
    ];

    public function sender()
    {
        return $this->belongsTo(User::class, 'sender_id', 'user_id');
    }

    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class, 'vehicle_id', 'vehicle_id');
    }
}
