#!/bin/bash

HTACCESS_PATH="./wordpress_data/.htaccess"
TEMP_FILE="./wordpress_data/.htaccess.tmp"
DIRECTIVES="php_value upload_max_filesize 64M
php_value post_max_size 64M
php_value max_execution_time 300
php_value max_input_time 300"

# Создаем временный файл
touch "$TEMP_FILE"

# Проверяем, существует ли файл .htaccess и наличие в нем '# END WordPress'
if [ -f "$HTACCESS_PATH" ]; then
    if grep -q "# END WordPress" "$HTACCESS_PATH"; then
        # Разделяем файл на части до и после '# END WordPress'
        # и вставляем директивы между ними
        awk "/# END WordPress/ {print \"$DIRECTIVES\"; found=1} {print} END {if(!found) print \"$DIRECTIVES\"}" "$HTACCESS_PATH" > "$TEMP_FILE"
    else
        # Если нет '# END WordPress', добавляем все в конец
        cat "$HTACCESS_PATH" > "$TEMP_FILE"
        echo -e "\n$DIRECTIVES" >> "$TEMP_FILE"
    fi
else
    # Если .htaccess не существует, создаем его с директивами
    echo "# BEGIN WordPress" > "$TEMP_FILE"
    echo "$DIRECTIVES" >> "$TEMP_FILE"
    echo "# END WordPress" >> "$TEMP_FILE"
fi

# Перемещаем временный файл обратно в .htaccess
mv "$TEMP_FILE" "$HTACCESS_PATH"
echo "Директивы успешно добавлены в $HTACCESS_PATH"
