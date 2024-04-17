# Drone image server

This is a PHP server that runs on the wildlife-camera that the drone will connect to in order to download the images taken by the camera.

## The API
This project is a simplied API that has the following endpoints:

| Endpoint                        | Description                                                                                                                                      |
|---------------------------------|--------------------------------------------------------------------------------------------------------------------------------------------------|
| GET /                           | Overview of commands                                                                                                                             |
| GET /images                     | Get a list of all image-ids on the camera                                                                                                        |
| GET /images?unacknowledged=true | Get a list of all undownloaded image-ids on the camera                                                                                           |   
| GET /images/\<id\>              | Get a tarball of the image along with JSON metadata                                                                                              |
| GET /images/\<id\>/raw          | Get the image file                                                                                                                               |
| GET /images/\<id\>/meta         | Get the image metadata JSON file                                                                                                                 |
| POST /images/\<id\>/ack         | **⚠️ Requires API key**<br/>Marks an image as successfully downloaded                                                                            |
| POST /time                      | **⚠️ Requires API key**<br/>Sets the time of the wild-life camera. The new time should be supplied in the request body a raw **ISO 8601** string |


## API key
Some POST requests require an API key to be supplied. The key should be supplied in the `X-API-KEY` header of request. If the API-key is not present or invalid, you will be met by return code `401`

## Development

In order to use this project, you need composer. Then run `composer install` on order to install all dependencies.  

This project requires URL re-writing. So you need to put it on a Nginx or Apache server.
The easiest way to this is to launch a Docker-container running the `php:8.2-apache` image and mounting this directory.

This can be done either using the CLI:

```bash
docker build -t wildlife-image-server .
docker run -p 6050:80 -v $(PWD)/src/:/var/www/html/ -v $(PWD)/debug_images:/var/www/debug_images -v $(PWD)/vendor:/var/www/vendor --rm --name "WildLifeImageServer" wildlife-image-server
```

The API should then be accessible on: http://localhost:6050

If using an IDE like PHPStorm, you can create a run-configuration that runs the image and binds the project-directory to `/var/www/html` in the container, as well as exposing a port.

