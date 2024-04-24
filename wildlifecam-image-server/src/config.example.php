<?php

const WILDLIFE_IMG_BASE_PATH = __DIR__ . "/../debug_images/";

const API_KEYS_SHA512 = [
    "run hash('sha512', '<YourApiKeyHere>' . API_KEY_SALT) and place the resulting value here"
];

const API_KEY_SALT = "SetMeToSomethingRandom";

const LOGS_TAG = "wildlifelogs";

const SET_TIME_ENABLED = false; // If "false", the time-endpoint will still exist, but it won't do anything (for debugging).