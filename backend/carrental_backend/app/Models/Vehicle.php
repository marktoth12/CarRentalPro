<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Vehicle extends Model
{
    use HasFactory;

    protected $table = 'vehicles';
    protected $primaryKey = 'vehicle_id';

    protected $fillable = [
        'rentalagent_id',
        'make',
        'model',
        'year',
        'license_plate',
        'daily_rate',
        'description',
        'fuel_type',
        'transmission_type',
        'number_of_seats',
        'location_pickup',
        'location_return',
        'is_available',
        'is_approved',
    ];

    protected $casts = [
        'upload_date' => 'datetime',
        'is_available' => 'boolean',
        'is_approved' => 'boolean',
    ];

    public function rentalAgent()
    {
        return $this->belongsTo(User::class, 'rentalagent_id', 'user_id');
    }

    public function images()
    {
        return $this->hasMany(VehicleImage::class, 'vehicle_id', 'vehicle_id');
    }

    public function rentals()
    {
        return $this->hasMany(Rental::class, 'vehicle_id', 'vehicle_id');
    }
}

