<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

class UpdateUsersTableStructure extends Migration
{
    /**
     * Run the migrations.
     *
     * @return void
     */
    public function up()
    {
        Schema::table('users', function (Blueprint $table) {
            // Add new columns
            $table->string('device_id')->after('email')->nullable();
            // Assuming 'name' field is kept for storing user's name from Gmail
            $table->string('google_account_id')->after('name')->unique()->nullable();
            $table->timestamp('last_updated')->default(DB::raw('CURRENT_TIMESTAMP'))->after('remember_token');

            // Make any necessary adjustments to existing columns
            // For example, ensuring 'email' is nullable if you plan to allow users without an email
            // $table->string('email')->nullable()->change();
        });
    }

    /**
     * Reverse the migrations.
     *
     * @return void
     */
    public function down()
    {
        Schema::table('users', function (Blueprint $table) {
            // Remove the columns you added
            $table->dropColumn(['device_id', 'google_account_id', 'last_updated']);
            
            // If you made changes to existing columns, reverse those changes
            // For example, if you made 'email' nullable above, revert it back
            // $table->string('email')->nullable(false)->change();
        });
    }
};

