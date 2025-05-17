<?php

namespace App\Http\Resources;

use Illuminate\Http\Request;
use Illuminate\Http\Resources\Json\JsonResource;

class ProjectResource extends JsonResource
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
            'description' => $this->description,
            'link' => $this->link,
            'thumbnail_url' => $this->thumbnail ? asset('storage/' . $this->thumbnail) : null,
            'tech' => $this->tech,
            'created_at' => $this->created_at->toDateTimeString(),
        ];
    }
}
