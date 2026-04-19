<?php

namespace App\Models;

// use Illuminate\Contracts\Auth\MustVerifyEmail;
use Database\Factories\UserFactory;
use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Foundation\Auth\User as Authenticatable;
use Illuminate\Notifications\Notifiable;

class User extends Authenticatable
{
    /** @use HasFactory<UserFactory> */
    use HasFactory, Notifiable;

    protected $table = 'users';
    protected $primaryKey = 'user_id';

    /**
     * The attributes that are mass assignable.
     *
     * @var list<string>
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

    /**
     * The attributes that should be hidden for serialization.
     *
     * @var list<string>
     */
    protected $hidden = [
        'password_hash',
        'remember_token',
    ];

    /**
     * Get the attributes that should be cast.
     *
     * @return array<string, string>
     */
    protected function casts(): array
    {
        return [
            'registration_date' => 'datetime',
            'date_of_birth' => 'date',
            'password_hash' => 'hashed',
            'is_approved' => 'boolean',
        ];
    }

    // Relationships
    public function vehicles()
    {
        return $this->hasMany(Vehicle::class, 'rentalagent_id', 'user_id');
    }

    public function rentals()
    {
        return $this->hasMany(Rental::class, 'user_id', 'user_id');
    }

    public function reviews()
    {
        return $this->hasMany(Review::class, 'reviewer_user_id', 'user_id');
    }

    public function applications()
    {
        return $this->hasMany(RentalagentApplication::class, 'user_id', 'user_id');
    }
}
