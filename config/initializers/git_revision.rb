# Get the deployed git revision to display in the footer
module Git
  REVISION = if Rails.env.production?
    revision = `SHA1=$(heroku releases -n=1 --json); if [ $SHA1 ]; then echo $SHA1; else echo 'unknown'; fi`.chomp
    puts revision.inspect, revision.class
    "#{revision['description'].gsub(/Deploy/)}"
  else
    `SHA1=$(git rev-parse --short HEAD 2> /dev/null); if [ $SHA1 ]; then echo $SHA1; else echo 'unknown'; fi`.chomp
  end
  VERSION = if Rails.env.production?
    "V#{revision['version']}"
  else
    `VERSION=$(git describe --tags 2> /dev/null); if [ $VERSION ]; then echo $VERSION; else echo 'unknown'; fi`.chomp
  end
end