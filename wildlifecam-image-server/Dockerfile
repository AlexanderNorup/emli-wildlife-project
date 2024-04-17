FROM php:8.2-apache

## PLEASE NOTE: This Dockerfile is PURELY for development!

# Enable rewrite engine
RUN a2enmod rewrite

# Debug: set development so errors show up!
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
