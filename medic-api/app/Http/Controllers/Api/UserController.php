<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Validator;
use App\Models\User;
use Laravel\Sanctum\HasApiTokens;

class UserController extends Controller
{
    use HasApiTokens;

    // Other methods remain the same

    /**
     * Verify or Create User based on Google Account ID
     * @param Request $request
     * @return \Illuminate\Http\Response
     */
    public function verifyOrCreateUser(Request $request)
    {
        // Validate the incoming request
        $validateUser = Validator::make($request->all(), 
        [
            'name' => 'required',
            'email' => 'required|email',
            'google_account_id' => 'required'
        ]);

        if ($validateUser->fails()) {
            return response()->json([
                'status' => false,
                'message' => 'Validation error',
                'errors' => $validateUser->errors()
            ], 401);
        }

        // Check if user exists based on google_account_id
        $user = User::where('google_account_id', $request->google_account_id)->first();

        if (!$user) {
            // If user does not exist, create a new user record
            $user = User::create([
                'name' => $request->name,
                'email' => $request->email,
                'google_account_id' => $request->google_account_id,
                'device_id' => $request->device_id ?? null, // Assuming device_id is optional and provided in the request
            ]);
        }

        // Regardless of new or existing user, generate a token for API access
        $tokenResult = $user->createToken('API TOKEN');
        $token = $tokenResult->plainTextToken;

        // Extract the token value
        $tokenValue = explode('|', $token, 2)[1] ?? $token;

        return response()->json([
            'status' => true,
            'message' => 'User verified successfully',
            'user' => [
                'user_id' => $user->id,
                'name' => $user->name,
                'email' => $user->email,
                'google_account_id' => $user->google_account_id,
                // Include any other user attributes you need to return
            ],
            'token' => $tokenValue
        ], 200);
    }
}
