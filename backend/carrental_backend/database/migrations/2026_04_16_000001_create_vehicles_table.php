<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('vehicles', function (Blueprint $table) {
            $table->id('vehicle_id');
            $table->foreignId('rentalagent_id')->constrained('users', 'user_id');
            $table->string('make', 50);
            $table->string('model', 50);
            $table->year('year');
            $table->string('license_plate', 10)->unique();
            $table->decimal('daily_rate', 10, 2);
            $table->text('description')->nullable();
            $table->enum('fuel_type', ['petrol', 'diesel', 'electric', 'hybrid']);
            $table->enum('transmission_type', ['manual', 'automatic']);
            $table->integer('number_of_seats');
            $table->string('location_pickup', 100);
            $table->string('location_return', 100);
            $table->boolean('is_available')->default(true);
            $table->timestamp('upload_date')->useCurrent();
            $table->boolean('is_approved')->default(false);
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('vehicles');
    }
};

