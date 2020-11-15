echo 'Usage:
  sh scaffold.sh g Song
  sh scaffold.sh d Song'
rails $1 my_scaffold $2 --no-migration --no-resource-route