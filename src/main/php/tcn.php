<?php

$file = $argv[1];
$xml = file_get_contents($file, FILE_TEXT);
$start = strpos($xml, '<metadata>') + 10;
$end = strpos($xml, '</metadata>');
$xml = substr($xml, $start, $end - $start);
file_put_contents($file, $xml, FILE_TEXT);

?>



