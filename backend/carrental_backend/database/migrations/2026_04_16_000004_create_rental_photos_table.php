<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('rental_photos', function (Blueprint $table) {
            $table->id('rental_photo_id');
            $table->foreignId('rental_id')->constrained('rentals', 'rental_id')->onDelete('cascade');
            $table->foreignId('uploader_user_id')->constrained('users', 'user_id');
            $table->string('image_url', 255);
            $table->enum('photo_type', ['pickup_user', 'pickup_rentalagent', 'return_user', 'return_rentalagent', 'damage_report']);
            $table->timestamp('upload_date')->useCurrent();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('rental_photos');
    }
};

