<?php

namespace App\Http\Middleware;

use Illuminate\Http\Request;
use Fideloper\Proxy\TrustProxies as Middleware;
use Symfony\Component\HttpFoundation\Request as SymfonyRequest;

class TrustProxies extends \Illuminate\Foundation\Configuration\Middleware
{
    /**
     * The trusted proxies for this application.
     *
     * Use '*' to trust all proxies (safe in container environments like Railway).
     *
     * @var array|string|null
     */
    protected $proxies = '*';

    /**
     * The headers that should be used to detect proxies.
     *
     * Use `HEADER_X_FORWARDED_ALL` to trust protocol (HTTPS), host, and port.
     *
     * @var int
     */
    protected $headers = SymfonyRequest::HEADER_X_FORWARDED_ALL;
}
