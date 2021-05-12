<?php

declare(strict_types=1);

return [
    'whitelist-global-classes' => true,
    'whitelist' => [
        'GrumPHP\*',
        'PhpParser\*',
        'Composer\*',
    ],
    'patchers' => [
        // Remove scoper namespace prefix from Symfony polyfills namespace
        static function (string $filePath, string $prefix, string $contents): string {
            if (!preg_match('{vendor/symfony/polyfill[^/]*/bootstrap.php}i', $filePath)) {
                return $contents;
            }

            return preg_replace('/namespace .+;/', '', $contents);
        },
        // Bug in scoper : it does not add class_alias if the interface is inside an if statement.
        // TODO : fix me on feedback in https://github.com/humbug/php-scoper/issues/473
        static function (string $filePath, string $prefix, string $contents): string {
            if ($filePath !== 'vendor/symfony/polyfill-php80/Resources/stubs/Stringable.php') {
                return $contents;
            }

            $contents .= 'if (\PHP_VERSION_ID < 80000) {'.PHP_EOL;
            $contents .= "    \class_alias('$prefix\\\\Stringable', 'Stringable', \\false);".PHP_EOL;
            $contents .= "}".PHP_EOL;

            return $contents;
        }
    ]
];
