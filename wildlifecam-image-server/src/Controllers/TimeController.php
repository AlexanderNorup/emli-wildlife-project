<?php

namespace LowEffortKandidat\Controllers;

use Pecee\SimpleRouter\SimpleRouter;

class TimeController
{
    public function setTime()
    {
        $requestBody = file_get_contents('php://input');
        $parsedTime = strtotime($requestBody);
        if(!trim($requestBody) || !$parsedTime) {
            SimpleRouter::response()->httpCode(400)->json(["message" => "Time input invalid"]);
        }

        $success = !SET_TIME_ENABLED;
        $timeCommandValue = date("Y-m-d H:i:s", $parsedTime);
        if(SET_TIME_ENABLED){
            exec("date -s \"$timeCommandValue\"", $_,$returnValue);
            $success = $returnValue == 0;
        }

        if ($_SERVER["HTTP_ACCEPT"] == "text/plain") {
            if($success){
                return "Time updated successfully";
            }else{
                SimpleRouter::response()->httpCode(500);
                return "Time update failed";
            }
        }

        if($success){
            SimpleRouter::response()->json(["message" => "Time updated successfully", "newTime" => $timeCommandValue, "dryRun" => !SET_TIME_ENABLED]);
        }else{
            SimpleRouter::response()->httpCode(500)->json(["message" => "Time update failed"]);
        }
    }
}