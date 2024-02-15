<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Article;
use Illuminate\Http\Request;

class ArticleController extends Controller
{
    /**
     * Display a listing of all articles.
     *
     * @return \Illuminate\Http\Response
     */
    public function index()
    {
        // Retrieve all articles without considering the delete_flag
        $articles = Article::all();
        return response()->json($articles);
    }

}
