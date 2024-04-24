<?php

namespace LowEffortKandidat\Controllers;

use Pecee\SimpleRouter\SimpleRouter;

class LogController
{
    public function getLogs()
    {
        $sort = "-r";
        if(isset($_GET['sort']) && $_GET['sort'] == "asc"){
            $sort = "";
        }

        $since = "";
        if(isset($_GET['since']) && strtotime($_GET['since']) > 0){
            $since = "--since=" . date("Y-m-d\TH:i:s", strtotime($_GET['since']));
        }

        $until = "";
        if(isset($_GET['until']) && strtotime($_GET['until']) > 0){
            $until = "--until=" . date("Y-m-d\TH:i:s", strtotime($_GET['until']));
        }

        $output = "";
        if(isset($_GET['output']) && $_GET['output'] == "json"){
            $output = "--output=json";
        }

        $limit = "";
        if(isset($_GET['limit']) && is_numeric($_GET['limit'])){
            $limit = "-n=".intval($_GET['limit']);
        }

        header("Content-Type: text/plain");
        system("journalctl $limit $since $until $output $sort -t " . LOGS_TAG);
    }
}