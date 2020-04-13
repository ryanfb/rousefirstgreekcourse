#!/bin/bash
# Requires:
# pdfimages, tesseract, uconv
# Run from project root, e.g.:
# ./scripts/generate-text.sh


if [ ! -e "orig/rousegreekcourse-016.png" ]; then
  echo "Splitting PDF into page images..."
  pdfimages -png orig/RouseGreekCourseResized.pdf orig/rousegreekcourse
fi
while read i; do
  TEXTFILE="text/$(basename $i .png | tr '-' '.')"
  if [ ! -e "${TEXTFILE}.txt" ]; then
    echo "Generating ${TEXTFILE}.txt from $i..."
    tesseract -l eng+grc orig/$i "$TEXTFILE" txt
    echo "Converting ${TEXTFILE}.txt to NFC..."
    uconv -x any-nfc ${TEXTFILE}.txt > ${TEXTFILE}.nfc && mv -v ${TEXTFILE}.nfc ${TEXTFILE}.txt
  fi
done < scripts/reading_pages.txt
