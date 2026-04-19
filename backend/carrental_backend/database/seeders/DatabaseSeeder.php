<?php

namespace Database\Seeders;

use App\Models\User;
use App\Models\Vehicle;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // Create Admin User
        $admin = User::create([
            'username' => 'admin',
            'email' => 'admin@carrentalpro.com',
            'password_hash' => bcrypt('password123'),
            'first_name' => 'Admin',
            'last_name' => 'User',
            'date_of_birth' => '1990-01-15',
            'driving_license_number' => 'DL123456789',
            'role' => 'admin',
            'user_status' => 'active',
            'is_approved' => true,
        ]);

        // Create Rental Agent
        $agent = User::create([
            'username' => 'agent',
            'email' => 'agent@carrentalpro.com',
            'password_hash' => bcrypt('password123'),
            'first_name' => 'Agent',
            'last_name' => 'Smith',
            'date_of_birth' => '1988-05-20',
            'driving_license_number' => 'DL987654321',
            'role' => 'rentalagent',
            'user_status' => 'active',
            'is_approved' => true,
        ]);

        // Create Regular User
        $user = User::create([
            'username' => 'john_doe',
            'email' => 'john@example.com',
            'password_hash' => bcrypt('password123'),
            'first_name' => 'John',
            'last_name' => 'Doe',
            'date_of_birth' => '1995-03-10',
            'driving_license_number' => 'DL555666777',
            'role' => 'user',
            'user_status' => 'active',
            'is_approved' => true,
        ]);

        // Create Sample Vehicles
        $vehicles = [
            [
                'make' => 'Toyota',
                'model' => 'Corolla',
                'year' => 2023,
                'license_plate' => 'ABC-1234',
                'daily_rate' => 49.99,
                'fuel_type' => 'petrol',
                'transmission_type' => 'automatic',
                'number_of_seats' => 5,
                'location_pickup' => 'Downtown Office',
                'location_return' => 'Downtown Office',
                'description' => 'Reliable sedan, perfect for city driving',
                'is_available' => true,
                'is_approved' => true,
            ],
            [
                'make' => 'Honda',
                'model' => 'CR-V',
                'year' => 2023,
                'license_plate' => 'XYZ-5678',
                'daily_rate' => 79.99,
                'fuel_type' => 'hybrid',
                'transmission_type' => 'automatic',
                'number_of_seats' => 7,
                'location_pickup' => 'Airport Terminal',
                'location_return' => 'Airport Terminal',
                'description' => 'Spacious SUV, great for family trips',
                'is_available' => true,
                'is_approved' => true,
            ],
            [
                'make' => 'BMW',
                'model' => '3 Series',
                'year' => 2023,
                'license_plate' => 'LUX-9999',
                'daily_rate' => 129.99,
                'fuel_type' => 'diesel',
                'transmission_type' => 'automatic',
                'number_of_seats' => 5,
                'location_pickup' => 'Premium Lounge',
                'location_return' => 'Premium Lounge',
                'description' => 'Luxury sedan with premium features',
                'is_available' => true,
                'is_approved' => true,
            ],
            [
                'make' => 'Nissan',
                'model' => 'Leaf',
                'year' => 2023,
                'license_plate' => 'EV-GREEN',
                'daily_rate' => 59.99,
                'fuel_type' => 'electric',
                'transmission_type' => 'automatic',
                'number_of_seats' => 5,
                'location_pickup' => 'Green Station',
                'location_return' => 'Green Station',
                'description' => 'Eco-friendly electric vehicle',
                'is_available' => true,
                'is_approved' => true,
            ],
            [
                'make' => 'Mercedes-Benz',
                'model' => 'C-Class',
                'year' => 2024,
                'license_plate' => 'MB-5000',
                'daily_rate' => 139.99,
                'fuel_type' => 'diesel',
                'transmission_type' => 'automatic',
                'number_of_seats' => 5,
                'location_pickup' => 'Premium Lounge',
                'location_return' => 'Premium Lounge',
                'description' => 'Elegant German luxury sedan with advanced technology',
                'is_available' => true,
                'is_approved' => true,
            ],
            [
                'make' => 'Audi',
                'model' => 'A4',
                'year' => 2024,
                'license_plate' => 'AUDI-A4',
                'daily_rate' => 119.99,
                'fuel_type' => 'petrol',
                'transmission_type' => 'automatic',
                'number_of_seats' => 5,
                'location_pickup' => 'Downtown Office',
                'location_return' => 'Downtown Office',
                'description' => 'Premium sedan with excellent performance and comfort',
                'is_available' => true,
                'is_approved' => true,
            ],
        ];

        foreach ($vehicles as $vehicleData) {
            $vehicleData['rentalagent_id'] = $agent->user_id;
            Vehicle::create($vehicleData);
        }
    }
}
