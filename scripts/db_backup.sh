#!/bin/bash

# ==============================================================================
# PostgreSQL Automated Backup & Retention Script
# Author: Dominic Ogeto
# Description: Performs a logical backup of the specified database and 
#              manages disk space by purging old backups.
# ==============================================================================

# --- Configuration ---
BACKUP_DIR="/var/lib/postgresql/backup"
DB_NAME="devops_project"
DATE=$(date +%Y-%m-%d_%H-%M-%S)
FILENAME="${BACKUP_DIR}/${DB_NAME}_${DATE}.sql"
RETENTION_DAYS=7

# Ensure backup directory exists
if [ ! -d "$BACKUP_DIR" ]; then
    echo "Creating backup directory: $BACKUP_DIR"
    mkdir -p "$BACKUP_DIR"
fi

# --- Execution ---
echo "----------------------------------------------------------"
echo "Backup Started: $(date)"
echo "Target Database: $DB_NAME"

# Perform the backup using pg_dump
# Note: Ensure the 'postgres' user has permissions to write to $BACKUP_DIR
pg_dump "$DB_NAME" > "$FILENAME"

if [ $? -eq 0 ]; then
    echo "Success: Backup saved to $FILENAME"
else
    echo "Error: Database backup failed!"
    exit 1
fi

# --- Retention Policy ---
echo "Cleaning up backups older than $RETENTION_DAYS days..."
find "$BACKUP_DIR" -type f -name "*.sql" -mtime +"$RETENTION_DAYS" -exec rm {} \;

echo "Backup Process Completed Successfully."
echo "----------------------------------------------------------"
