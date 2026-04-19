<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class RentalPhoto extends Model
{
    use HasFactory;

    protected $table = 'rental_photos';
    protected $primaryKey = 'rental_photo_id';

    protected $fillable = [
        'rental_id',
        'uploader_user_id',
        'image_url',
        'photo_type',
    ];

    protected $casts = [
        'upload_date' => 'datetime',
    ];

    public function rental()
    {
        return $this->belongsTo(Rental::class, 'rental_id', 'rental_id');
    }

    public function uploader()
    {
        return $this->belongsTo(User::class, 'uploader_user_id', 'user_id');
    }
}

