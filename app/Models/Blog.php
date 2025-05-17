<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;
use Illuminate\Support\Str;

class Blog extends Model
{
    protected $table = 'blogs';

    protected $fillable = [
        'title',
        'slug',
        'content',
        'thumbnail'
    ];

    public function getHtmlContentAttribute(): string
    {
        $content = $this->content;

        return preg_replace_callback(
            '/<pre>(.*?)<\/pre>/s',
            function ($matches) {
                $code = html_entity_decode(trim($matches[1]));

                $language = 'plaintext';

                if (str_starts_with($code, '<?php') || str_contains($code, 'namespace') || str_contains($code, 'use Illuminate')) {
                    $language = 'php';
                } elseif (str_contains($code, 'console.log') || str_contains($code, 'function')) {
                    $language = 'javascript';
                } elseif (str_contains($code, '<div') || str_contains($code, '</html>')) {
                    $language = 'html';
                } elseif (str_contains($code, 'SELECT') || str_contains($code, 'FROM')) {
                    $language = 'sql';
                }

                return '<pre><code class="language-' . $language . '">' . e($code) . '</code></pre>';
            },
            $content
        );
    }
}
