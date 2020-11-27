<?php

declare(strict_types=1);

return [
    'whitelist' => [
        'GrumPHP\*',
        'PhpParser\*',
        'Composer\*'
    ],
    'patchers' => [
        // Remove scoper namespace prefix from Symfony polyfills namespace
        static function (string $filePath, string $prefix, string $contents): string {
            if (!preg_match('{vendor/symfony/polyfill[^/]*/bootstrap.php}i', $filePath)) {
                return $contents;
            }

            return preg_replace('/namespace .+;/', '', $contents);
        },
    ]
];
