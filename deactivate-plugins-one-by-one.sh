#!/bin/bash

# This script is designed to systematically deactivate and reactivate WordPress plugins
# while excluding WooCommerce. It uses WP-CLI to manage plugin operations.

# Key features:
# 1. Skips plugins and themes during WP-CLI operations to avoid conflicts
# 2. Retrieves a list of active plugins, excluding WooCommerce
# 3. Deactivates each plugin one by one
# 4. Waits for user confirmation before reactivating each plugin
# 5. Provides feedback on each step of the process

# The script is useful for:
# - Troubleshooting plugin conflicts
# - Performing maintenance on plugins individually
# - Identifying problematic plugins without affecting WooCommerce functionality

# Note: This script requires WP-CLI to be installed and properly configured
# on the system where it's being run.


# Define WP-CLI options for skipping plugins and themes
WP_CLI_OPTIONS="--skip-plugins --skip-themes"

# Get a list of all active plugins, excluding WooCommerce
active_plugins=$(wp plugin list --status=active --field=name $WP_CLI_OPTIONS | grep -v 'woocommerce')

# Loop through each active plugin
for plugin in $active_plugins; do
    # Deactivate the plugin
    echo "Deactivating plugin: $plugin"
    wp plugin deactivate $plugin $WP_CLI_OPTIONS

    # Wait for user input before proceeding
    read -p "Plugin $plugin deactivated. Press [Enter] to reactivate and proceed to the next plugin..."

    # Reactivate the plugin
    echo "Reactivating plugin: $plugin"
    wp plugin activate $plugin $WP_CLI_OPTIONS
    echo
done

echo "All applicable plugins have been processed."
