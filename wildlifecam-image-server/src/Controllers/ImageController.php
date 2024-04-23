<?php

namespace LowEffortKandidat\Controllers;

require_once "config.php";
require_once "Entities/WildLifeImage.php";

use LowEffortKandidat\Entities\WildLifeImage;
use Pecee\SimpleRouter\SimpleRouter;
use PharData;

class ImageController
{
    /**
     * @type WildLifeImage[]
     */
    private array $files = [];

    public function __construct()
    {
        $this->files = [];
        $this->recursivelyFindImages(WILDLIFE_IMG_BASE_PATH, $this->files);
    }

    public function getAllImages()
    {
        $onlyUnacknowledged = isset($_GET['unacknowledged']) && $_GET['unacknowledged'] === 'true';
        $imageIds = array_keys($this->files);

        if ($onlyUnacknowledged) {
            // Improvement TODO: Use some kind of cache here instead of reading all JSON files
            $imageIds = array_values(array_filter($imageIds, function ($imgId) {
                return !isset($this->files[$imgId]->getMetaData()["Drone Copy"]);
            }));
        }

        // If the client ONLY accepts text/plain, we give them that
        if ($_SERVER["HTTP_ACCEPT"] == "text/plain") {
            return join("\n", $imageIds);
        }

        //Otherwise, we give them json
        SimpleRouter::response()->json($imageIds);
    }

    public function getTarBall($id)
    {
        if (!isset($this->files[$id])) {
            SimpleRouter::response()->httpCode(404)->json(["message" => "Image not found"]);
        }

        $img = $this->files[$id];

        $tmp = tempnam(sys_get_temp_dir(), 'WildLifeCam') . ".tar";
        $archive = new PharData($tmp);
        $archive->addFile($img->getImageFile(), $img->getImageFileName() . ".jpg");
        $archive->addFile($img->getMetaFile(), $img->getImageFileName() . ".json");

        header("Content-Disposition: attachment; filename=\"" . $img->getImageFileName() . ".tar\"");
        header("Content-type: application/x-tar");
        readfile($tmp);

        // Delete temporary file
        unlink($tmp);
    }

    public function viewImage($id)
    {
        if (!isset($this->files[$id])) {
            SimpleRouter::response()->httpCode(404)->json(["message" => "Image not found"]);
        }

        header("Content-type: image/jpeg");
        readfile($this->files[$id]->getImageFile());
    }

    public function viewMetadata($id)
    {
        if (!isset($this->files[$id])) {
            SimpleRouter::response()->httpCode(404)->json(["message" => "Image not found"]);
        }

        header("Content-type: application/json");
        readfile($this->files[$id]->getMetaFile());
    }

    public function acknowledgedDownload($id)
    {
        if (!isset($this->files[$id])) {
            SimpleRouter::response()->httpCode(404)->json(["message" => "Image not found"]);
        }

        $requestBody = file_get_contents('php://input');
        if(!trim($requestBody) || strlen($requestBody) > 50) {
            SimpleRouter::response()->httpCode(400)->json(["message" => "This request requires the drone-name to be supplied as plain-text (<=50 chars) in the request body."]);
        }

        $meta = $this->files[$id]->getMetaData();
        if($meta == NULL){
            SimpleRouter::response()->httpCode(500)->json(["message" => "The metadata for this file is not valid JSON, so we cannot acknowledge it. Contact a developer."]);
        }
        $meta["Drone Copy"] = [
            "Drone ID" => $requestBody,
            "Seconds Epoch" => microtime(true),
        ];
        file_put_contents($this->files[$id]->getMetaFile(), json_encode($meta));

        // If the client ONLY accepts text/plain, we give them that
        if ($_SERVER["HTTP_ACCEPT"] == "text/plain") {
            return "Download Acknowledged";
        }

        SimpleRouter::response()->json(["message" => "Download acknowledged"]);
    }

    private function recursivelyFindImages($searchDir, $wildLifeImages, $depth = 0)
    {
        if ($depth > 10) {
            throw new \Exception("Circular folder-structure or folder-path to deep");
        }
        foreach (scandir($searchDir) as $file) {
            if ($file == "." || $file == "..") {
                continue;
            }

            $path = $searchDir . DIRECTORY_SEPARATOR . $file;

            if (is_dir($path)) {
                $this->recursivelyFindImages($path, $wildLifeImages, $depth + 1);
                continue;
            }

            if (!preg_match("/\d{6}_\d{3}\.jpg$/i", $file)) {
                continue;
            }

            try {
                $image = new WildLifeImage($path);
                $this->files[$image->getImageId()] = $image;
            } catch (\Exception $e) {
                // Invalid image. Maybe log this?
                // echo "Skipping " . $path . " because: " . $e;
            }
        }
    }
}