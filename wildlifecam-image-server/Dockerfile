FROM php:8.2-apache

## PLEASE NOTE: This Dockerfile is PURELY for development!

# Setup SUDO permissions for the www-data user to set the time
RUN apt-get update && \
      apt-get -y install sudo

## Install systemd for journalctl command
RUN apt-get -y install systemd

## Allow the www-data user to run "sudo date"
RUN echo 'www-data ALL=(ALL) NOPASSWD: /usr/bin/date' >> /etc/sudoers

# Enable rewrite engine
RUN a2enmod rewrite

# Debug: set development so errors show up!
RUN mv "$PHP_INI_DIR/php.ini-development" "$PHP_INI_DIR/php.ini"
