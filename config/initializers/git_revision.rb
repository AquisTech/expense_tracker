# Get the deployed git revision to display in the footer
module Git
  REVISION = `SHA1=$(git rev-parse --short HEAD 2> /dev/null); if [ $SHA1 ]; then echo $SHA1; else echo 'unknown'; fi`.chomp
  VERSION = `VERSION=$(git describe --tags 2> /dev/null); if [ $VERSION ]; then echo $VERSION; else echo 'unknown'; fi`.chomp
  BRANCH = `BRANCH=$(git rev-parse --abbrev-ref HEAD 2> /dev/null); if [ $BRANCH ]; then echo $BRANCH; else echo 'unknown'; fi`.chomp
end