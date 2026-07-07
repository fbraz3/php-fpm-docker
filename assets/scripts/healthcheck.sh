#!/bin/bash

# PHP-FPM Docker Healthcheck Script
# Verifies that PHP-FPM is running and listening

set -e

# Check PHP-FPM by connecting to its configured port (1780)
if </dev/tcp/127.0.0.1/1780; then
    exit 0
else
    echo "Health check failed: PHP-FPM is not responding on port 1780"
    exit 1
fi
