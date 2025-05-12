#!/bin/bash
current=$(setxkbmap -query | grep "layout:" | awk '{print $2}')
if [ "$current" = "us" ]; then
  setxkbmap br
else
  setxkbmap us
fi
