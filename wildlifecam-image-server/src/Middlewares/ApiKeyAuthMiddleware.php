<?php

namespace LowEffortKandidat\Middlewares;

use Pecee\Http\Middleware\IMiddleware;
use Pecee\Http\Request;
use Pecee\SimpleRouter\SimpleRouter;

require_once "config.php";

class ApiKeyAuthMiddleware implements IMiddleware {
    public function handle(Request $request): void
    {
        $providedApiKey = $request->getHeader("X-API-KEY");

        if($providedApiKey == NULL){
            SimpleRouter::response()->httpCode(401)->json(["message" => "Missing API key."]);
        }

        $hashApiKey = hash("sha512", $providedApiKey . API_KEY_SALT);

        if(!in_array($hashApiKey, API_KEYS_SHA512)){
            SimpleRouter::response()->httpCode(401)->json(["message" => "Invalid API key."]);
        }

        // API Key OK
    }
}