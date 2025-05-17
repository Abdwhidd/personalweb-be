<?php

use Illuminate\Support\Facades\Route;
use App\Models\Blog;
use App\Models\Project;
use App\Http\Resources\BlogResource;
use App\Http\Resources\ProjectResource;

Route::prefix('v1')->group(function () {
    Route::get('/blogs', fn () => BlogResource::collection(Blog::latest()->get()));

    Route::get('/blogs/{slug}', function ($slug) {
        $blog = Blog::where('slug', $slug)->firstOrFail();
        return new BlogResource($blog);
    });

    Route::get('/projects', fn () => ProjectResource::collection(Project::latest()->get()));
});
