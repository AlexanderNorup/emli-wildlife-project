<?php

namespace LowEffortKandidat;

require_once "../vendor/autoload.php";
require_once "Controllers/ImageController.php";
require_once "Middlewares/ApiKeyAuthMiddleware.php";

use LowEffortKandidat\Controllers\ImageController;
use LowEffortKandidat\Middlewares\ApiKeyAuthMiddleware;
use Pecee\Http\Request;
use Pecee\SimpleRouter\SimpleRouter;

// Routes
SimpleRouter::get('/images', [ImageController::class, 'getAllImages']);
SimpleRouter::get('/images/{id}', [ImageController::class, 'getTarBall']);
SimpleRouter::get('/images/{id}/raw', [ImageController::class, 'viewImage']);
SimpleRouter::get('/images/{id}/meta', [ImageController::class, 'viewMetadata']);

//Routes requiring auth
SimpleRouter::group(['middleware' => ApiKeyAuthMiddleware::class], function () {
    SimpleRouter::post('/images/{id}/ack', [ImageController::class, 'acknowledgedDownload']);
});

// Config and front-page

SimpleRouter::get('/', function () {
    SimpleRouter::response()->json([
        "message" => "Welcome to the WildLife Image Server",
        "endpoints" => array_map(function ($route) {
            return $route->getUrl();
        }, SimpleRouter::router()->getProcessedRoutes()),
    ]);
});

SimpleRouter::error(function (Request $request, \Exception $exception) {
    SimpleRouter::response()->httpCode($exception->getCode())->json([
        "message" => $exception->getMessage(),
        "code" => $exception->getCode(),
    ]);
});
SimpleRouter::start();
