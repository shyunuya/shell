#!/bin/bash
# SYNTAX: bash mailer_util.sh <FROM> <TO> <SUBJECT> <ATTACHMENT>
# EXAMPLE: bash mailer_util.sh "$FROM" "$TO" "$SUBJECT" "$CSVFILE"

FROM=$1
TO=$2
SUBJECT=$3
boundary="ZZ_/afg6432dfgkl.94531q"
body=`cat "$4"`

declare -a attachments
attachments=( $5 )

get_mimetype(){
  # warning: assumes that the passed file exists
  file --mime-type "$1" | sed 's/.*: //' 
}

# Build headers
{

printf '%s\n' "From: $FROM
To: $TO
Subject: $SUBJECT
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=\"$boundary\"

--${boundary}
Content-Type: text/plain; charset=\"US-ASCII\"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

$body
"
 
# now loop over the attachments, guess the type
# and produce the corresponding part, encoded base64
for file in "${attachments[@]}"; do

  [ ! -f "$file" ] && echo "Warning: attachment $file not found, skipping" >&2 && continue

  mimetype=$(get_mimetype "$file") 
 
  printf '%s\n' "--${boundary}
Content-Type: $mimetype
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename=\"$file\"
"
 
  base64 "$file"
  echo
done
