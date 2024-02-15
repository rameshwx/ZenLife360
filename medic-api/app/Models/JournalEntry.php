<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class JournalEntry extends Model
{
    protected $fillable = ['user_id', 'date', 'content', 'delete_flag', 'upload_flag', 'last_updated'];
        
}
