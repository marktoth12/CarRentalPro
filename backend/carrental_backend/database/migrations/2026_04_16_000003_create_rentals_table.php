<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('rentals', function (Blueprint $table) {
            $table->id('rental_id');
            $table->foreignId('user_id')->constrained('users', 'user_id');
            $table->foreignId('vehicle_id')->constrained('vehicles', 'vehicle_id');
            $table->dateTime('start_date');
            $table->dateTime('end_date');
            $table->dateTime('actual_return_date')->nullable();
            $table->string('pickup_location', 100);
            $table->string('return_location', 100);
            $table->decimal('total_price', 10, 2);
            $table->enum('rental_status', ['pending_approval', 'approved', 'rejected', 'in_progress', 'completed', 'cancelled'])->default('pending_approval');
            $table->timestamp('rental_request_date')->useCurrent();
            $table->dateTime('rentalagent_decision_date')->nullable();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('rentals');
    }
};

