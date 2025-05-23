<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class BlogResource extends JsonResource
{
    /**
     * Transform the resource into an array.
     *
     * @return array<string, mixed>
     */
    public function toArray(Request $request): array
    {
        return [
            'id' => $this->id,
            'title' => $this->title,
            'slug' => $this->slug,
            'content' => $this->html_content,
            'thumbnail_url' => $this->thumbnail ? asset('storage/' . $this->thumbnail) : null,
            'created_at' => $this->created_at->toDateTimeString(),
        ];
    }
}
