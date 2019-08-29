# GrumPHP shim

This package provides GrumPHP without the struggle of installing all of its dependencies.

## Usage

Currently this shim is still beta and not globally available in composer.
This means you'll need to configure a repository in the meantime:

```bash
composer config repositories.grumphp-shim vcs https://github.com/phpro/grumphp-shim
```

Install the package

```bash

composer require --dev phpro/grumphp-shim
```

and use it like the original executable

```bash
vendor/bin/grumphp.phar run
```

Check out the main repo for more options [https://github.com/phpro/grumphp](https://github.com/phpro/grumphp).


## TODO

- Rewrite composer hook so that it requires NO dependencies and copy from source!! (Currently not useable ...)
- Register phive repository : https://github.com/phar-io/phar.io/blob/master/data/repositories.xml
- Optionally: Inject https://github.com/humbug/phar-updater during build
