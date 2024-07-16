#!/bin/bash

# Funzione per verificare se un comando esiste
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Aggiorna i pacchetti e installa MySQL e wget se non sono già installati
if ! command_exists mysql; then
    echo "MySQL non è installato. Installazione in corso..."
    sudo apt-get update
    sudo apt-get install -y mysql-server
fi

if ! command_exists mysqldump; then
    echo "mysqldump non è installato. Installazione in corso..."
    sudo apt-get update
    sudo apt-get install -y mysql-client
fi

if ! command_exists wget; then
    echo "wget non è installato. Installazione in corso..."
    sudo apt-get update
    sudo apt-get install -y wget
fi

# Parametri di connessione al database
DB_USER="tuo_utente"
DB_PASSWORD="tua_password"
DB_NAME="nome_database"
DB_OUTPUT_FILE="database_backup.sql"

# Directory in cui salvare i dati
OUTPUT_DIR="$HOME/Desktop/website_backup"

# URL del sito web da scaricare
WEBSITE_URL="http://esempio.com"

# Crea la directory di output se non esiste
mkdir -p "$OUTPUT_DIR"

# Esegui il dump del database
echo "Eseguendo il dump del database..."
mysqldump -u"$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" > "$OUTPUT_DIR/$DB_OUTPUT_FILE"

if [ $? -eq 0 ]; then
    echo "Dump del database completato. File salvato in $OUTPUT_DIR/$DB_OUTPUT_FILE."
else
    echo "Errore durante il dump del database."
    exit 1
fi

# Usa wget per scaricare l'intero sito web
echo "Scaricando il sito web..."
wget --mirror --convert-links --adjust-extension --page-requisites --no-parent -P "$OUTPUT_DIR" "$WEBSITE_URL"

if [ $? -eq 0 ]; then
    echo "Download del sito web completato. I dati sono stati salvati nella directory $OUTPUT_DIR."
else
    echo "Errore durante il download del sito web."
    exit 1
fi

echo "Operazioni completate con successo."