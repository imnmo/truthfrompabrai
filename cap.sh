#!/bin/bash
# cap.sh videoUrl sub.txt  
# https://stackoverflow.com/questions/59244045/how-to-modify-this-sed-awk-command-so-that-the-output-goes-to-a-file-of-choice/61296419#61296419
# https://stackoverflow.com/questions/42334372/removing-time-stamp-with-sed
# Add this bit https://github.com/explosion/spaCy/issues/5222

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

cat sub.txt | sed -E 's/[0-9]{2}:[0-9]{2}:[0-9]{2}//' > sub_final.txt

cat Trying_to_Solve_the_Investment_Puzzle___Chuck_Akre___Talks_at_Google-O38I7QIc_eQ.en.vtt | sed -E 's/[0-9]{2}:[0-9]{2}:[0-9]{2}\.[0-999]{3}//g' > sub_gtalk_akre_final_parsed.txt
