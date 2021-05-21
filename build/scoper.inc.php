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
    'whitelist' => [
        'GrumPHP\*',
        'PhpParser\*',
        'Composer\*',
        'Symfony\\Polyfill\\*',
    ],
    'files-whitelist' => [
        ...$polyfillsBootstraps,
        ...$polyfillsStubs
    ],
    'patchers' => []
];
