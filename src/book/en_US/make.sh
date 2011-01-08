#! /bin/bash

./00-master.tex.lua >/tmp/00-master.tex && pdflatex -halt-on-error /tmp/00-master.tex
