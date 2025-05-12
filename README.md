# Braz PHP-FPM Docker

A lightweight and multi-version PHP-FPM Docker image designed to integrate seamlessly with web servers like Nginx or Apache HTTP Server.

This image is optimized for performance, security, and flexibility, making it ideal for production environments.

💡 For a complete list of available images, please visit the [PHP System Docs](https://github.com/fbraz3/php-system-docs) page.

## Table of Contents

- [Braz PHP-FPM Docker](#braz-php-fpm-docker)
  - [Build Status](#build-status)
  - [Tags](#tags)
  - [Flavors](#flavors)
  - [Manage PHP Directives via Environment Variables](#manage-php-directives-via-environment-variables)
  - [Cronjobs](#cronjobs)
  - [Sending Mails](#sending-mails)
  - [Contribution](#contribution)
  - [Donation](#donation)
  - [License](#license)

## Build Status

[![Build Base Images](https://github.com/fbraz3/php-fpm-docker/actions/workflows/base-images.yml/badge.svg)](https://github.com/fbraz3/php-fpm-docker/actions/workflows/base-images.yml) [![Build Phalcon Images](https://github.com/fbraz3/php-fpm-docker/actions/workflows/phalcon-images.yml/badge.svg)](https://github.com/fbraz3/php-fpm-docker/actions/workflows/phalcon-images.yml)

## Tags
Each image is tagged with the PHP version. For example:
- `fbraz3/php-fpm:8.4` for PHP 8.4
- `fbraz3/php-fpm:8.4-phalcon` for PHP 8.4 with Phalcon extension 

Check the available tags on `Docker Hub`: <https://hub.docker.com/r/fbraz3/php-fpm/tags>.

## Flavors
The image is available in different flavors to suit your needs:
- **Vanilla**: A minimal PHP-FPM image with essential configurations.
- **Phalcon**: An image with the Phalcon PHP framework pre-installed.

## Manage PHP Directives via Environment Variables
You can configure PHP directives dynamically using environment variables. The following prefixes are supported:
- `PHPADMIN_`: Sets `php_admin_value` directives.
- `PHPFLAG_`: Sets `php_flag` directives.
- `FPMCONFIG_`: Configures PHP-FPM settings.
- `POOLCONFIG_`: Configures PHP-FPM pool settings.

Example:
```
PHPADMIN_memory_limit: 256M
PHPFLAG_display_errors: Off
FPMCONFIG_pm_max_children: 10
POOLCONFIG_listen: 127.0.0.1:9000
```

#### Useful Links

- [DeepWiki Page](https://deepwiki.com/fbraz3/php-fpm-docker) (AI generated DOCS).
- [PHP-FPM Configuration](https://www.php.net/manual/en/install.fpm.configuration.php)
- [PHP-FPM Pool Configuration](https://www.php.net/manual/en/install.fpm.configuration.php#install.fpm.configuration.pools)
- [PHP-FPM Environment Variables](https://www.php.net/manual/en/install.fpm.configuration.php#install.fpm.configuration.environment)
- [PHP-FPM Admin Values](https://www.php.net/manual/en/install.fpm.configuration.php#install.fpm.configuration.admin)
- [PHP-FPM Flags](https://www.php.net/manual/en/install.fpm.configuration.php#install.fpm.configuration.flags)

## Cronjobs
The system automatically installs cron jobs from the `/cronfile` file.

To use it, bind your cron file to `/cronfile`:
```
volumes:
- /path/to/your/cronfile:/cronfile
```

## Sending Mails
This image supports sending emails using the `mail()` function.

For more details, refer to the [PHP Base Docker documentation](https://github.com/fbraz3/php-base-docker#sending-mails).

## Contribution
Contributions are welcome! Feel free to open issues or submit pull requests to improve the project.

Please visit the [CONTRIBUTING.md](CONTRIBUTING.md) file for guidelines on how to contribute to this project.

#### Useful links
- [How to create a pull request](https://docs.github.com/pt/pull-requests/collaborating-with-pull-requests/proposing-changes-to-your-work-with-pull-requests/creating-a-pull-request)
- [How to report an issue](https://docs.github.com/pt/issues/tracking-your-work-with-issues/creating-an-issue)

## Donation
I spend a lot of time and effort maintaining this project. If you find it useful, consider supporting me with a donation:
- [GitHub Sponsor](https://github.com/sponsors/fbraz3)
- [Patreon](https://www.patreon.com/fbraz3)

## License

This project is licensed under the [Apache License 2.0](LICENSE), so you can use it for personal and commercial projects. However, please note that the images are provided "as is" without any warranty or guarantee of any kind. Use them at your own risk.