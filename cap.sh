#!/bin/bash
# cap.sh videoUrl sub.txt  
# https://stackoverflow.com/questions/59244045/how-to-modify-this-sed-awk-command-so-that-the-output-goes-to-a-file-of-choice/61296419#61296419

# Download captions only and save in a .vtt file
youtube-dl --skip-download --write-auto-sub "$1";

# Find .vtt files in current directory created within last 3 seconds, limit to 1
vtt=$(find . -cmin -0.05 -name "*.vtt" | head -1)

# Extract the subs and save as plaintext, removing time, new lines and other markup
sed '1,/^$/d' "$vtt" \
  | sed 's/<[^>]*>//g' \
  | awk -F. 'NR%8==1{$1}NR%8==3' \
  | tr '\n' ' ' > "$2"

# Remove the original .vtt subs file
rm -f "$vtt"