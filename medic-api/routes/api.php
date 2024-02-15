<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\UserController;
use App\Http\Controllers\Api\ArticleController;
use App\Http\Controllers\Api\JournalEntryController;
use App\Http\Controllers\Api\UserBMIEntryController;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider and all of them will
| be assigned to the "api" middleware group. Make something great!
|
*/

Route::post('/auth/verify', [UserController::class, 'verifyOrCreateUser']);
Route::get('/auth/articles', [ArticleController::class, 'index']);
Route::get('/auth/journal-entries/{userId}', [JournalEntryController::class, 'getByUserId']);
Route::post('/auth/journal-entries', [JournalEntryController::class, 'store']);
Route::get('/auth/user-bmi-entries/{userId}', [UserBMIEntryController::class, 'getByUserId']);
Route::post('/auth/user-bmi-entries', [UserBMIEntryController::class, 'store']);
// Route::middleware('auth:sanctum')->get('/auth/getAllUsers', [UserController::class, 'getAllUsers']);
