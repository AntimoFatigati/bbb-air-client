#!/bin/bash
brand=$1
echo "Copying assets from $1/assets to src/assets ..."
cp -a $1/assets/* src/assets/
echo "Done!"
