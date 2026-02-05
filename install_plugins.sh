#!/bin/bash

MOODLE_PATH="/bitnami/moodle"

# Provera da li su pluginovi vec instalirani (gledamo Moove temu kao marker)
if [ -d "$MOODLE_PATH/theme/moove" ]; then
    echo "--- Pluginovi su vec prisutni. Preskacem download. ---"
else
    echo "--- Zapocinjem instalaciju edX pluginova... ---"

    # Instalacija unzip alata ako ne postoji
    apt-get update && apt-get install -y unzip curl

    # 1. Moove Tema
    curl -L https://moodle.org/plugins/download.php/31034/theme_moove_moodle43_2023121500.zip -o moove.zip
    unzip -q -o moove.zip -d $MOODLE_PATH/theme/ && rm moove.zip

    # 2. Tiles Format
    curl -L https://moodle.org/plugins/download.php/30554/format_tiles_moodle43_2023111000.zip -o tiles.zip
    unzip -q -o tiles.zip -d $MOODLE_PATH/course/format/ && rm tiles.zip

    # 3. Completion Progress
    curl -L https://moodle.org/plugins/download.php/30062/block_completion_progress_moodle43_2023091100.zip -o progress.zip
    unzip -q -o progress.zip -d $MOODLE_PATH/blocks/ && rm progress.zip

    # 4. Custom Certificate
    curl -L https://moodle.org/plugins/download.php/30129/mod_customcert_moodle43_2023091900.zip -o cert.zip
    unzip -q -o cert.zip -d $MOODLE_PATH/mod/ && rm cert.zip

    # Postavljanje ispravnih permisija za Bitnami korisnika
    chown -R 1001:1001 /bitnami/moodle /bitnami/moodledata
    
    echo "--- Pluginovi uspesno skinuti i otpakovani. ---"
fi


echo "--- Primena edX dizajna (CSS) na Moove temu... ---"

# Definišemo CSS u varijabli
EDX_CSS="body { background-color: #f8f9fa !important; font-family: 'Inter', sans-serif !important; } #page-content { max-width: 1100px; margin: 20px auto !important; background: #fff; padding: 40px !important; border: 1px solid #e1e4e8; } .breadcrumb { display: none !important; } .format-tiles .tile { border: 1px solid #e1e4e8 !important; border-radius: 4px !important; } .btn-primary { background-color: #055271 !important; border-color: #055271 !important; border-radius: 2px !important; text-transform: uppercase; font-weight: 600; }"

# Ubrizgavamo CSS direktno u podešavanja teme Moove
# Napomena: Moodle čuva Raw SCSS u 'theme_moove_scss' postavci
php $MOODLE_PATH/admin/cli/cfg.php --component=theme_moove --name=scssextra --set="$EDX_CSS"

# Čistimo keš da bi promene bile vidljive odmah
php $MOODLE_PATH/admin/cli/purge_caches.php

echo "--- Dizajn je primenjen i kes je ociscen! ---"
# Pokretanje Moodle nadogradnje baze (uvek se pokrece za svaki slucaj)
echo "--- Provera nadogradnje baze podataka... ---"
php $MOODLE_PATH/admin/cli/upgrade.php --non-interactive