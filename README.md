# docker-zurmo
A Zurmo Docker container

A docker container, including docker-compose configuration for local development/testing with mysql and memcache.

Initial installation of Zurmo is run at the command-line, if the bootstrap script does not find a perInstance.php file for the present installation.

See bootstrap.sh for a list of configuration environment variables and default values. The defaults are geared toward compatibility with the included docker-compose.yml file.

A makefile is included for convenience in creating the mysql data container; run make make-data.

To persist settings across builds, inject the perInstance.php and debug.php files into the public/app/protected/config directory.

This package uses a git mirror of the Zurmo mercurial repository, and is currently checked out on a branch that includes some adjustments to the install script to allow for a non-localhost memcache instance. See https://github.com/bradjones1/Zurmo/commit/4fbda99fe6e21af120fa3d71adcc1b2c1bbd2b99 and the linked mercurial pull request.
