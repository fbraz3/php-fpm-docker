# Braz PHP-FPM Docker: Instructions for AI Coding Agents

## What I Am
A lightweight and multi-version PHP-FPM Docker image designed to integrate seamlessly with web servers like Nginx or Apache HTTP Server.

## Key Concepts and Rules
- **Environment Variables for Configuration**: PHP directives are configured dynamically using specific prefixes:
  - `PHPADMIN_`: Sets `php_admin_value` directives.
  - `PHPFLAG_`: Sets `php_flag` directives.
  - `FPMCONFIG_`: Configures PHP-FPM settings.
  - `POOLCONFIG_`: Configures PHP-FPM pool settings.
- **Flavors**: Images are available in different flavors (e.g., `Vanilla`, `Phalcon`). Ensure any new features or extensions respect these flavor boundaries.
- **Cronjobs**: Cron jobs are supported by binding a cron file to `/cronfile`.
- **Mails**: The image supports sending emails using the `mail()` function, relying on the underlying PHP Base Docker behavior.
- **Contributions & Issues**: Never report security-related issues publicly. Sensitive bugs must be reported appropriately.

## Repository Structure & Documentation
- **README.md**: Contains the core documentation for end-users, including tags and environment variables.
- **CONTRIBUTING.md**: Guidelines for reporting bugs and suggesting enhancements.
- **docker-compose.yml**: Used for local testing and development.
- **flavors/**: Directory containing definitions for different image flavors (like Phalcon).
- **assets/**: Additional files and scripts used during the Docker build process.

## Code Conventions
- When updating Dockerfiles or entrypoint scripts, ensure compatibility across different PHP versions.
- All code, comments, and documentation should be in English.
- Be concise and provide reproduction steps when dealing with bugs.
