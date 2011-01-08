#! /bin/bash

set -e

ROOT="${BASH_SOURCE[0]}";
if ([ -h "${ROOT}" ]) then
  while([ -h "${ROOT}" ]) do ROOT=`readlink "${ROOT}"`; done
fi
ROOT="$(cd `dirname "${ROOT}"` && cd ../../.. && pwd)" # Up three levels

SRC="${ROOT}/src/book/en_US"
OUT_PDF="${ROOT}/out/pdf/lua-cookbook.pdf"
OUT_HTML="${ROOT}/out/html/lua-cookbook.html"

find "${SRC}" -name "*.md" | sort | xargs markdown2pdf -o "${OUT_PDF}"
find "${SRC}" -name "*.md" | sort | xargs pandoc --toc -o "${OUT_HTML}"
