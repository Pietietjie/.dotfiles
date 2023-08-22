#!/usr/bin/bash

versionAliasFile="/tmp/php_version.dat"

if [ "$1" ]; then
    if [ "$1" == "php"* ]; then
        versionAlias="$1";
    elif [[ "$1" =~ ^[0-9]\.?[0-9]?$ ]]; then
        versionAlias="php$1";
    fi
fi

if [ ! "$versionAlias" ]; then
    if [ ! -f "$versionAliasFile" ]; then
        versionAlias="php7";
    else
        versionAlias=$(cat "$versionAliasFile");
    fi
fi


echo "${versionAlias}";

# and save it for next time
echo "${versionAlias}" > "$versionAliasFile";
