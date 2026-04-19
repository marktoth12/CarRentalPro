<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Factories\HasFactory;

class Review extends Model
{
    use HasFactory;

    protected $table = 'reviews';
    protected $primaryKey = 'review_id';

    protected $fillable = [
        'rental_id',
        'reviewer_user_id',
        'reviewed_user_id',
        'rating',
        'comment',
    ];

    protected $casts = [
        'review_date' => 'datetime',
    ];

    public function rental()
    {
        return $this->belongsTo(Rental::class, 'rental_id', 'rental_id');
    }

    public function reviewer()
    {
        return $this->belongsTo(User::class, 'reviewer_user_id', 'user_id');
    }

    public function reviewed()
    {
        return $this->belongsTo(User::class, 'reviewed_user_id', 'user_id');
    }
}

