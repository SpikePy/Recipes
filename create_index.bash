#!/usr/bin/env bash

################################################################################
#
# This Script generates the index.html which links to all recipes.
# It also creates a pre-commit hook that builds the index.html whenever 
# a new commit is done
#
################################################################################

function create_pre_commit_hook() {
    # Only copy this script to .git/hooks/pre-commit if files differ
    if ! diff --brief $0 .git/hooks/pre-commit > /dev/null; then
        cp --force "$0" .git/hooks/pre-commit
        echo "Updated pre-commit hook"
    fi
}

function create_index_html() {
    # Change internal field seperator to ";" instead of " " to enable strings with spaces as array elements
    IFS=";"
    local recipes
    recipes=($(grep --recursive --only-matching --perl-regexp --ignore-case '(?<=<h1>).*(?=</h1>)' ./recipes))
    readonly recipes

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

    # Add generated index.html to commit
    git add ./index.html

    # Console output
    echo "Created index.html with recipes"
    for recipe in "${recipes[@]}"; do
        echo "  - ${recipe##*:}"
    done
}

function main() {
    create_pre_commit_hook
    create_index_html
}

main