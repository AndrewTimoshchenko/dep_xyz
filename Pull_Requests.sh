#!/bin/bash

for i in {1..68}
do


# Кількість ітерацій (за замовчуванням 5)
ITERATIONS=${1:-2}

# Перевіряємо, чи встановлено GitHub CLI
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI (gh) не знайдено. Встановіть його з https://cli.github.com/"
    exit 1
fi

# Генеруємо випадкову назву гілки
BRANCH_NAME="feature/random-scripts-$(openssl rand -hex 2)"

# Створюємо нову гілку
git checkout -b "$BRANCH_NAME"

# Функція для генерації випадкового імені файлу
generate_filename() {
    EXTENSIONS=("sh" "py" "js" "txt")
    EXT="${EXTENSIONS[$RANDOM % ${#EXTENSIONS[@]}]}"
    echo "$(openssl rand -hex 3).$EXT"
}

# Функція для генерації псевдокоду
generate_fake_code() {
    local EXT="$1"
    case "$EXT" in
        "sh")
            echo -e "#!/bin/bash\n\nfor i in {1..5}; do\n  echo \"Processing item \$i\"\n  sleep 1\ndone"
            ;;
        "py")
            echo -e "#!/usr/bin/env python3\n\nfor i in range(5):\n    print(f'Processing item {i}')\n    import time\n    time.sleep(1)"
            ;;
        "js")
            echo -e "for (let i = 0; i < 5; i++) {\n  console.log(`Processing item ${i}`);\n  await new Promise(r => setTimeout(r, 1000));\n}"
            ;;
        "txt")
            echo -e "TODO List:\n- Implement random script generator\n- Optimize performance\n- Add more randomization"
            ;;
    esac
}

# Запускаємо цикл
for ((i=1; i<=ITERATIONS; i++)); do
    FILENAME=$(generate_filename)
    EXT="${FILENAME##*.}"

    generate_fake_code "$EXT" > "$FILENAME"

    if [[ "$EXT" == "sh" || "$EXT" == "py" ]]; then
        chmod +x "$FILENAME"
    fi

    git add "$FILENAME"
    git commit -m "Added random fake script: $FILENAME"

    echo "[$i/$ITERATIONS] Створено і закомічено файл: $FILENAME"
done

# Пушимо всі коміти разом у нову гілку
git push origin "$BRANCH_NAME"

# Створюємо Pull Request через GitHub CLI
gh pr create --base main --head "$BRANCH_NAME" --title $BRANCH_NAME --body "This PR adds $ITERATIONS randomly generated scripts."

echo "✅ Pull Request створено для гілки: $BRANCH_NAME"

done