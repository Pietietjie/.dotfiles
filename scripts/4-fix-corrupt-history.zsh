#!/usr/bin/env zsh

# Repairs a corrupt zsh history file in extended format (`: <ts>:<dur>;<cmd>`).
#
#   - strips invalid byte sequences
#   - drops empty-command entries
#   - restores chronological order
#   - drops consecutive duplicate commands
#
# Multi-line entries (trailing backslash) are kept intact.

set -euo pipefail

histfile=${1:-${HISTFILE:-$HOME/.zsh_history}}

if [[ ! -f $histfile ]]; then
    echo "no history file at $histfile" >&2
    exit 1
fi

backup=$histfile.bak.$(date +%Y%m%d%H%M%S)
cp -- "$histfile" "$backup"

workdir=$(mktemp -d)
trap 'rm -rf -- "$workdir"' EXIT

iconv -c -f UTF-8 -t UTF-8 -- "$backup" > "$workdir/clean" || cp -- "$backup" "$workdir/clean"

awk '
    function flush() {
        if (have) printf "%d\t%s\n", ts, buf
        have = 0
        buf = ""
    }
    /^: [0-9]+:[0-9]+;/ && !cont {
        flush()
        hdr = $0
        sub(/^: /, "", hdr)
        sub(/:.*/, "", hdr)
        ts = hdr + 0
        buf = $0
        have = 1
        cont = /\\$/
        next
    }
    {
        if (have) buf = buf SEP $0
        else { ts = 0; buf = $0; have = 1 }
        cont = /\\$/
    }
    END { flush() }
' SEP=$'\001' "$workdir/clean" > "$workdir/flat"

sort -s -n -k1,1 -- "$workdir/flat" > "$workdir/sorted"

awk -v SEP=$'\001' '
    {
        entry = $0
        sub(/^[^\t]*\t/, "", entry)
        gsub(SEP, "\n", entry)

        cmd = entry
        sub(/^: [0-9]+:[0-9]+;/, "", cmd)

        probe = cmd
        gsub(/[ \t\n\\]/, "", probe)
        if (probe == "") { empty++; next }

        if (cmd == prev) { dup++; next }
        prev = cmd

        print entry
        kept++
    }
    END {
        printf "kept %d, removed %d empty, removed %d duplicate\n", kept, empty, dup > "/dev/stderr"
    }
' "$workdir/sorted" > "$workdir/out"

cat -- "$workdir/out" > "$histfile"

echo "repaired $histfile"
echo "backup: $backup"
echo "reload with: fc -R $histfile   (or exec zsh)"
