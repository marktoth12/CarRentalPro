<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\VehicleController;
use App\Http\Controllers\RentalagentApplicationController;
use App\Http\Controllers\AuthController;
use App\Http\Controllers\RentalController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\VehicleImageController;
use App\Http\Controllers\RentalPhotoController;
use App\Http\Controllers\UserController;
use App\Http\Controllers\ContactMessageController;
use App\Http\Controllers\VehicleMessageController;

Route::post('/login', [AuthController::class, 'login']);
Route::post('/contact', [ContactMessageController::class, 'store']);
Route::post('/register', [AuthController::class, 'register']);
Route::get('/vehicles', [VehicleController::class, 'index']);
Route::get('/vehicles/{id}', [VehicleController::class, 'show']);

Route::middleware('auth:sanctum')->group(function () {
    Route::get('/user', function (Request $request) {
        return $request->user();
    });

    Route::post('/vehicles', [VehicleController::class, 'store']);
    Route::put('/vehicles/{id}', [VehicleController::class, 'update']);
    Route::delete('/vehicles/{id}', [VehicleController::class, 'destroy']);

    Route::get('/rentals', [RentalController::class, 'index']);
    Route::apiResource('rentals', RentalController::class)->except(['index']);
    Route::apiResource('reviews', ReviewController::class);
    Route::apiResource('vehicle-images', VehicleImageController::class);
    Route::apiResource('rental-photos', RentalPhotoController::class);
    Route::apiResource('rentalagent-applications', RentalagentApplicationController::class);
    Route::post('rentalagent-applications/{id}/approve', [RentalagentApplicationController::class, 'approve']);
    Route::post('rentalagent-applications/{id}/reject', [RentalagentApplicationController::class, 'reject']);
    Route::apiResource('users', UserController::class);
    Route::get('/contact-messages', [ContactMessageController::class, 'index']);
    Route::patch('/contact-messages/{id}/read', [ContactMessageController::class, 'markRead']);
    Route::delete('/contact-messages/{id}', [ContactMessageController::class, 'destroy']);
    Route::post('/vehicle-messages', [VehicleMessageController::class, 'store']);
    Route::get('/vehicle-messages', [VehicleMessageController::class, 'index']);
    Route::patch('/vehicle-messages/{id}/read', [VehicleMessageController::class, 'markRead']);
    Route::delete('/vehicle-messages/{id}', [VehicleMessageController::class, 'destroy']);
});
