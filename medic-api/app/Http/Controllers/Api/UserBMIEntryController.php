<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\UserBMIEntry;
use Illuminate\Http\Request;

class UserBMIEntryController extends Controller
{
    /**
     * Display a listing of BMI entries for a specific user.
     *
     * @param  int  $userId
     * @return \Illuminate\Http\Response
     */
    public function getByUserId($userId)
    {
        $bmiEntries = UserBMIEntry::where('user_id', $userId)
                                  ->where('delete_flag', false)
                                  ->orderBy('entry_date', 'desc')
                                  ->get();

        return response()->json(['bmiEntries' => $bmiEntries]);
    }

    /**
     * Store or update a BMI entry.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|integer|exists:users,id',
            'weight' => 'required|numeric',
            'height' => 'required|numeric',
            'bmi_value' => 'required|numeric',
            'entry_date' => 'required|date',
        ]);

        // Define conditions for finding an existing entry
        $conditions = [
            'user_id' => $request->user_id,
            'entry_date' => $request->entry_date,
        ];

        // Data to insert or update
        $bmiEntryData = [
            'weight' => $request->weight,
            'height' => $request->height,
            'bmi_value' => $request->bmi_value,
            'delete_flag' => $request->delete_flag ?? false,
            'upload_flag' => $request->upload_flag ?? true,
        ];

        $bmiEntry = UserBMIEntry::updateOrCreate($conditions, $bmiEntryData);

        return response()->json(['message' => 'BMI entry processed successfully', 'bmiEntry' => $bmiEntry], 201);
    }
}
