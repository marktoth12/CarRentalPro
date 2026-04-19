<?php

use App\Http\Controllers\VehicleController;
use App\Http\Controllers\RentalController;
use App\Http\Controllers\ReviewController;
use App\Http\Controllers\VehicleImageController;
use App\Http\Controllers\RentalPhotoController;
use App\Http\Controllers\PenaltyPointsLogController;
use App\Http\Controllers\RentalagentApplicationController;
use App\Http\Controllers\UserController;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

// Public endpoints
Route::apiResource('vehicles', VehicleController::class)->only(['index', 'show']);

// Protected endpoints
Route::middleware('auth:sanctum')->group(function () {
    // Vehicles
    Route::apiResource('vehicles', VehicleController::class)->only(['store', 'update', 'destroy']);

    // Rentals
    Route::apiResource('rentals', RentalController::class);

    // Reviews
    Route::apiResource('reviews', ReviewController::class);

    // Vehicle Images
    Route::apiResource('vehicle-images', VehicleImageController::class);

    // Rental Photos
    Route::apiResource('rental-photos', RentalPhotoController::class);

    // Rental Agent Applications
    Route::apiResource('rentalagent-applications', RentalagentApplicationController::class);
    Route::post('rentalagent-applications/{id}/approve', [RentalagentApplicationController::class, 'approve']);
    Route::post('rentalagent-applications/{id}/reject', [RentalagentApplicationController::class, 'reject']);

    // Users
    Route::apiResource('users', UserController::class);
});
