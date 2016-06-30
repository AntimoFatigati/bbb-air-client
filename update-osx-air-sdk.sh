#!/bin/bash
# automated script to update Flex SDK on OSX 
# made by following the guide: http://jeffwinder.blogspot.it/2011/09/installing-adobe-air-3-sdk-in-flash.html 
#
# @author Alex Gotev

######## NOTICE!! ##########################################################################
# The AdobeAIRSDK.tbz2 included here is 22.0.0.153
# Maybe there is an updated version here when you read this:
#
# http://www.adobe.com/devnet/air/air-sdk-download.html
# 
# so go there with your browser and download the latest sdk without the compiler
# At the time fo this writing the Adobe website has the following note:
# Note: Flex users will need to download the original AIR SDK without the new compiler.
# Download the Mac version and replace the one in this directory before running this script
############################################################################################

SDKPATH=/Applications/Adobe\ Flash\ Builder\ 4.6/sdks/
SDKVERSION="22.0.0.153"

CURDIR=$(pwd)

# GitHub limits uploaded file sizes to 100M, so the files has been splitted with:
# ./split-adobe-air-sdk-before-github-push.sh
# before pushing it to the repo
# reassembling it...
cat AdobeAIRSDK.tbz2.* > AdobeAIRSDK.tbz2

cd "$SDKPATH"
cp -a 4.6\.0/ "$SDKVERSION"
cp "$CURDIR/AdobeAIRSDK.tbz2" "$SDKPATH/$SDKVERSION/"
cd "$SDKVERSION"
tar jxvf AdobeAIRSDK.tbz2
rm -rf AdobeAIRSDK.tbz2

cat <<EOF > flex-sdk-description.xml
<?xml version="1.0"?>
<flex-sdk-description>
<name>$SDKVERSION</name>
<version>4.6.0</version>
<build>23201</build>
</flex-sdk-description>

EOF

cd frameworks/libs/player/
mkdir 11.0
cd 11.0
curl -L https://fpdownload.macromedia.com/get/flashplayer/updaters/22/playerglobal22_0.swc -o playerglobal.swc 
