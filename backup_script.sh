#!/bin/bash

# Function to check if a file or folder exists
function check_existence() {
    if [ -e "$1" ]; then
        return 0
    else
        echo "Error: File or folder '$1' does not exist."
        exit 1
    fi
}

# Function to validate the backup location
function validate_backup_location() {
    if [ -d "$(dirname "$1")" ]; then
        return 0
    else
        echo "Error: Invalid backup location."
        exit 1
    fi
}

# Enable script to exit on error
set -e

# Prompt for files/folders
read -p "Enter the path of the file/folder to back up (separate multiple entries with spaces): " input_files

# Validate input files
for file in $input_files; do
    check_existence "$file"
done

# Prompt for backup location and name
read -p "Enter the path and name of the backup file: " backup_location
validate_backup_location "$backup_location"

# Ask for compression
read -p "Do you want to apply compression to the backup? (y/n): " compress_backup
if [ "$compress_backup" = "y" ]; then
    compression_option="-czvf"
else
    compression_option="-cvf"
fi

# Execute backup
tar "$compression_option" "$backup_location" $input_files
# tar "$compression_option" "$backup_location" "$input_files"


# Report completion
echo "Backup completed successfully."

# Schedule backup
(crontab -l ; echo "0 15 */2 * 1 /bin/tar -cjvf /tmp/backup.tar.bz2 -C /home/viveksachdev") | crontab -
