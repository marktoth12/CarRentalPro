<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('reviews', function (Blueprint $table) {
            $table->id('review_id');
            $table->foreignId('rental_id')->unique()->constrained('rentals', 'rental_id')->onDelete('cascade');
            $table->foreignId('reviewer_user_id')->constrained('users', 'user_id');
            $table->foreignId('reviewed_user_id')->constrained('users', 'user_id');
            $table->integer('rating');
            $table->text('comment')->nullable();
            $table->timestamp('review_date')->useCurrent();
            $table->timestamps();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('reviews');
    }
};

