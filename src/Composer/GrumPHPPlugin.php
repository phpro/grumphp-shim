<?php

declare(strict_types=1);

namespace GrumPHP\Composer;

use Composer\Composer;
use Composer\IO\IOInterface;
use Composer\Plugin\PluginInterface;

class GrumPHPPlugin implements PluginInterface
{
    public function activate(Composer $composer, IOInterface $io)
    {
        $io->write('<fg=yellow>GrumPHP shim registered. you\'ll need to activate grumphp manually for now.</fg=yellow>');
    }
}
