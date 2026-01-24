#!/bin/sh

draw(){ kitten icat --stdin no --transfer-mode memory \
  --place "${w}x${h}@${x}x${y}" "$1" </dev/null >/dev/tty; exit 1; }

file=$1 w=$2 h=$3 x=$4 y=$5
mime=$(file -Lb --mime-type "$file")

case $mime in
  image/*) draw "$file" ;;
  video/*)
    t=$(mktemp --suffix=.png)
    ffmpegthumbnailer -i "$file" -o "$t" -s 0 -t 10% -q 8
    draw "$t"; rm -f "$t"
    ;;
  *) bat --color=always --style=plain "$file" 2>/dev/null || sed -n '1,200p' "$file" ;;
esac
