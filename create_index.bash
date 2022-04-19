#!/usr/bin/env bash

if [[ ! -f .git/hooks/pre-commit ]]; then
    cp "$0" .git/hooks/pre-commit
    echo "Created pre-commit hook"
fi


# Change internal field seperator to ";" instead of " " to enable strings with spaces as array elements
IFS=";"
recipes=($(grep --recursive --only-matching --perl-regexp --ignore-case '(?<=<h1>).*(?=</h1>)' ./recipes))

cat << EOF > ./index.html
<!DOCTYPE html>
<html lang="en">
<meta charset="UTF-8">
<title>Spikes Recipes</title>
<meta name="viewport" content="width=device-width,initial-scale=1">
<link rel="stylesheet" href="style.css">

<body>
    <h1>Recipes</h1>
    <ul>
        $(for recipe in "${recipes[@]}"; do echo "<li><a href=\"${recipe%%:*}\">${recipe##*:}</a></li>"; done)
    </ul>
</body>

</html>
EOF

echo "Created index.html with recipes"

git add ./index.html