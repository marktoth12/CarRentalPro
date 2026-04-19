<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Rental extends Model
{
    use HasFactory;

    protected $table = 'rentals';
    protected $primaryKey = 'rental_id';

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

    protected $casts = [
        'start_date' => 'datetime',
        'end_date' => 'datetime',
        'actual_return_date' => 'datetime',
        'rental_request_date' => 'datetime',
        'rentalagent_decision_date' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    public function vehicle()
    {
        return $this->belongsTo(Vehicle::class, 'vehicle_id', 'vehicle_id');
    }

    public function photos()
    {
        return $this->hasMany(RentalPhoto::class, 'rental_id', 'rental_id');
    }

    public function review()
    {
        return $this->hasOne(Review::class, 'rental_id', 'rental_id');
    }
}

