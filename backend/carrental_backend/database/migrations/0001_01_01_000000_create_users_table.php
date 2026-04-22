<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('users', function (Blueprint $table) {
            $table->id('user_id'); // PONTOS EGYEZÉS: user_id
            $table->string('username')->unique();
            $table->string('email')->unique();
            $table->string('password_hash'); // PONTOS EGYEZÉS
            $table->string('first_name');
            $table->string('last_name');
            $table->date('date_of_birth');
            $table->string('driving_license_number')->unique();
            $table->enum('role', ['admin', 'rentalagent', 'user'])->default('user');
            $table->enum('user_status', ['active', 'inactive', 'suspended'])->default('active');
            $table->boolean('is_approved')->default(0);
            $table->timestamps();
        });

        Schema::create('sessions', function (Blueprint $table) {
            $table->string('id')->primary();
            $table->foreignId('user_id')->nullable()->constrained('users', 'user_id');
            $table->string('ip_address', 45)->nullable();
            $table->text('user_agent')->nullable();
            $table->longText('payload');
            $table->integer('last_activity')->index();
        });
    }

    public function down(): void
    {
        Schema::dropIfExists('sessions');
        Schema::dropIfExists('users');
    }
};
