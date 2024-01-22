#!/bin/bash
wcal -C \
| sed -e "s/\x1b//g" \
| sed -e "s/\[4m//g" \
| sed -e "s/\[0m//g" \
| sed -e "s/\[7m/\$\{color black\}/g" \
| sed -e "s/\[27m/\$\{color white\}/g" \
| sed -e "s/\[7m//g" \
| sed -e "s/\[7m//g" \
