# Author: Jodie Putrino
# Date last updated: 02/18/2016
#
# This script is base on one authored by https://gist.github.com/hugorodgerbrown/5317616.
# It will convert a directory full .md files into .rst equivalents. It uses
# pandoc to do the conversion.
#
# 1. Install pandoc from http://johnmacfarlane.net/pandoc/
# 2. Copy this script into the directory containing the files to be converted
# 3. Ensure that the script has execute permissions
# 4. Run the script
#
# By default this will keep the original file
#

FILES=*.md
for f in $FILES
do
# extension="${f##*.}"
filename="${f%.*}"
echo "Converting $f to $filename.rst"
`pandoc $f -t markdown -o $filename.rst`
# uncomment this line to delete the source file.
# rm $f
done
