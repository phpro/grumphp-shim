<?php

$composerFile = __DIR__.'/composer.json';

$composerContent = file_get_contents($composerFile);
$composerData = json_decode($composerContent, true);

file_put_contents($composerFile.'.backup', $composerContent);
file_put_contents(
    $composerFile,
    json_encode(
        array_merge_recursive($composerData, [
            'require' => [
                'nikic/php-parser' => '~4.0',
            ],
            'scripts' => [
                'post-autoload-dump' => [
                    'GrumPHP\\Composer\\FixBrokenStaticAutoloader::fix'
                ],
            ]
        ]),
        JSON_PRETTY_PRINT
    )
);
