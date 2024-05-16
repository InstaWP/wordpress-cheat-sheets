#!/bin/bash

echo "Performing backup and core file update..."

# Backup wp-content
echo "Backing up wp-content directory..."
cp -r wp-content wp-content-backup

# Backup wp-config.php
echo "Backing up wp-config.php file..."
cp wp-config.php wp-config-backup.php

# Backup .htaccess
echo "Backing up .htaccess file..."
cp .htaccess .htaccess-backup

# Backup MySQL database
echo "Exporting MySQL database..."
wp db export 

# Replace WordPress core files
echo "Downloading and replacing WordPress core files..."
version=$(wp core version --skip-plugins --skip-themes)
wp core download --version=$version --force --skip-content 

# Run wp core verify-checksums
echo "Verifying WordPress core checksums..."
core=$(wp core verify-checksums --skip-plugins --skip-themes 2>&1)

# Find lines with warnings and extract file paths
echo "$core" | grep "Warning: File should not exist" | cut -d: -f3 | cut -c2- > core.txt

# Delete all files listed in core.txt
echo "Deleting files which shouldn't exist after verification..."
while read line; do
  rm $line
done < core.txt

echo "Backup and core file update completed."
