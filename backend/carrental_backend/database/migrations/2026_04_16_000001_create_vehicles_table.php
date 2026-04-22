<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('vehicles', function (Blueprint $table) {
            $table->id('vehicle_id'); // PONTOS EGYEZÉS: vehicle_id
            $table->unsignedBigInteger('rentalagent_id');
            $table->string('brand', 50);
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
            $table->boolean('is_available')->default(1);
            $table->boolean('is_approved')->default(0);
            $table->timestamps();

            // IDEGEN KULCS BEÁLLÍTÁSA A DUMP ALAPJÁN
            $table->foreign('rentalagent_id')
                ->references('user_id') // A Users tábla user_id mezőjére
                ->on('users');
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('vehicles');
    }
};
