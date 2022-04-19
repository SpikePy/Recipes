#!/usr/bin/env bash

echo "Create index.html with recipes"

# Change internal field seperator to ";" instead of " " to enable strings with spaces as array elements
IFS=";"
recipes=($(grep --recursive --only-matching --perl-regexp --ignore-case '(?<=<h1>)[a-z _-]*' ./recipes))

echo "${recipes[0]}"

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