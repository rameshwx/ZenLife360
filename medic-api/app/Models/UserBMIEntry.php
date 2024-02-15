<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class UserBMIEntry extends Model
{
    protected $fillable = ['user_id', 'weight', 'height', 'bmi_value', 'entry_date', 'delete_flag', 'upload_flag', 'last_updated'];

}
