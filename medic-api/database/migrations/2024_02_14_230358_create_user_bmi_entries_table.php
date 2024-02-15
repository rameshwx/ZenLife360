<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class CreateUserBmiEntriesTable extends Migration
{
    public function up()
    {
        Schema::create('user_bmi_entries', function (Blueprint $table) {
            $table->id('bmi_entry_id');
            $table->foreignId('user_id')->constrained()->onDelete('cascade');
            $table->decimal('weight', 8, 2);
            $table->decimal('height', 8, 2);
            $table->decimal('bmi_value', 8, 2);
            $table->date('entry_date');
            $table->boolean('delete_flag')->default(false);
            $table->boolean('upload_flag')->default(false);
            $table->timestamp('last_updated')->default(DB::raw('CURRENT_TIMESTAMP'));
        });
    }

    public function down()
    {
        Schema::dropIfExists('user_bmi_entries');
    }
}

