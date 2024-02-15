<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\JournalEntry;
use Illuminate\Http\Request;

class JournalEntryController extends Controller
{
    /**
     * Display a listing of journal entries for a specific user.
     *
     * @param  int  $userId
     * @return \Illuminate\Http\Response
     */
    public function getByUserId($userId)
    {
        $journalEntries = JournalEntry::where('user_id', $userId)
                                       ->where('delete_flag', false)
                                       ->orderBy('date', 'desc')
                                       ->get();

        return response()->json(['journalEntries' => $journalEntries]);
    }

    /**
     * Store or update a journal entry.
     *
     * @param  \Illuminate\Http\Request  $request
     * @return \Illuminate\Http\Response
     */
    public function store(Request $request)
    {
        $request->validate([
            'user_id' => 'required|integer|exists:users,id',
            'date' => 'required|date',
            'content' => 'required|string',
        ]);

        // Define conditions for finding an existing entry
        $conditions = [
            'user_id' => $request->user_id,
            'date' => $request->date,
        ];

        // Data to insert or update
        $entryData = [
            'content' => $request->content,
            'delete_flag' => $request->delete_flag ?? false,
            'upload_flag' => $request->upload_flag ?? true,
        ];

        $journalEntry = JournalEntry::updateOrCreate($conditions, $entryData);

        return response()->json(['message' => 'Journal entry processed successfully', 'journalEntry' => $journalEntry], 201);
    }
};
