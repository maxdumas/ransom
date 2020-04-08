#!/bin/zsh

set -euo pipefail

TEXT="$@"
CHAR_HEIGHT=64
CHAR_WIDTH=64

fonts=($(convert -list font | awk -F: '/^\ *Font: /{print substr($NF,2)}'))
colors=($(convert -list Color | awk '{print $1}'))

for i in {1..$#TEXT}; do
    c=$TEXT[i]
    if [ $c = ' ' ]; then
        convert -size ${CHAR_WIDTH}x${CHAR_HEIGHT} xc:white "__$i.png"
    else
        font="$fonts[$[$RANDOM%$#fonts+1]]"
        fgcolor="$colors[$[$RANDOM%$#colors+1]]"
        bgcolor="transparent"
        rotation=$[$RANDOM%30-15]
        convert -size ${CHAR_WIDTH}x${CHAR_HEIGHT} -rotate $rotation -background "$bgcolor" -gravity center -fill "$fgcolor" -font "$font" label:"$c" "__$i.png"
    fi
done

convert __{1..$#TEXT}.png -colorspace SRGB -set page "+%[fx:$CHAR_WIDTH*t]+0" -background white -layers merge +repage output.png

rm -f __*.png
