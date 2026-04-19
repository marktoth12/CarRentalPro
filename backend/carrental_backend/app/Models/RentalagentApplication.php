<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class RentalagentApplication extends Model
{
    use HasFactory;

    protected $table = 'rentalagent_applications';
    protected $primaryKey = 'application_id';

    protected $fillable = [
        'user_id',
        'status',
        'admin_id',
        'decision_date',
    ];

    protected $casts = [
        'application_date' => 'datetime',
        'decision_date' => 'datetime',
    ];

    public function user()
    {
        return $this->belongsTo(User::class, 'user_id', 'user_id');
    }

    public function admin()
    {
        return $this->belongsTo(User::class, 'admin_id', 'user_id');
    }
}

