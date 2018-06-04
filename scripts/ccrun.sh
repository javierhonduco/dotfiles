set -euo pipefail

if [ "$#" = 0 ]; then
  echo "usage: ccrun 'code'"
  echo "example: ccrun 'printf(\"Hi!\\n\");'"
  exit 1
fi

program_body=$1

mkdir -p /tmp/ccrun
tempfolder=$(mktemp /tmp/ccrun/XXXXXX)
headers="
  #include <limits.h>
  #include <stdio.h>
  #include <sys/types.h>
  #include <unistd.h>
"

template="$headers int main(){ $program_body }"
CC='gcc'
CFLAGS='-Wall'

echo "$template" | $CC -o "$tempfolder" $CFLAGS -xc -
$tempfolder
