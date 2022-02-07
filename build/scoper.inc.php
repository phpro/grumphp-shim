<?php

declare(strict_types=1);

use Symfony\Component\Finder\Finder;

$polyfillsBootstraps = array_map(
    static fn (SplFileInfo $fileInfo) => $fileInfo->getPathname(),
    iterator_to_array(
        Finder::create()
              ->files()
              ->in(__DIR__ . '/vendor/symfony/polyfill-*')
              ->name('bootstrap.php'),
        false,
    ),
);

$polyfillsStubs = array_map(
    static fn (SplFileInfo $fileInfo) => $fileInfo->getPathname(),
    iterator_to_array(
        Finder::create()
              ->files()
              ->in(__DIR__ . '/vendor/symfony/polyfill-*/Resources/stubs')
              ->name('*.php'),
        false,
    ),
);

return [
    'exclude-namespaces' => [
        'GrumPHP',
        'PhpParser',
        'Composer',
        'Symfony\Polyfill',
    ],
    'exclude-files' => [
        ...$polyfillsBootstraps,
        ...$polyfillsStubs
    ],
    /*
     * Expose global symbols fixes issues like `trigger_deprecation()` inside Symfony.
     * These global function gets scoped, but the usage is not replaced.
     */
    'expose-global-functions' => true,
    'expose-global-classes' => true,
    'expose-global-constants' => true,
    'patchers' => []
];
