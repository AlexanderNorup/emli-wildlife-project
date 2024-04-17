<?php

namespace LowEffortKandidat\Entities;

class WildLifeImage
{
    private $imageId;
    private $imageFileName;
    private $imageFile;
    private $metaFile;

    public function __construct(string $imageFile)
    {
        if (!file_exists($imageFile)) {
            throw new \Exception("Image file does not exist!");
        }
        $pathInfo = pathinfo($imageFile);
        $metaFile = $pathInfo["dirname"] . DIRECTORY_SEPARATOR . $pathInfo["filename"] . ".json";
        if (!file_exists($metaFile)) {
            throw new \Exception("Image file does not have a matching .json file");
        }

        $this->imageId = str_replace("/", "_", basename($pathInfo["dirname"]) . DIRECTORY_SEPARATOR . $pathInfo["filename"]);
        $this->imageFileName = $pathInfo["filename"];
        $this->metaFile = $metaFile;
        $this->imageFile = $imageFile;
    }

    public function getImageId(): string
    {
        return $this->imageId;
    }

    public function getImageFileName(): string
    {
        return $this->imageFileName;
    }

    public function getImageFile(): string
    {
        return $this->imageFile;
    }

    public function getMetaFile(): string
    {
        return $this->metaFile;
    }

    public function getMetaData(): array
    {
        return json_decode(file_get_contents($this->metaFile), true);
    }
}