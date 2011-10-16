DRUSH_PATH="/usr/local/bin/drush"

#arg handling in alfred sucks, lets split it up
#query="{query}"
#IFS=" "
#set -- $query

proj=''
site=''

gotodo() {
  open http://${site}drupal.org/${proj}/${nid}
}

check() {
  if [[ "$nid" =~ ^[0-9]+$ ]] ; then
    return 0
  else
    return 1
  fi
}

case "$1" in
  d)
    shift
    ${DRUSH_PATH} $@
    ;;
  g)
    nid=$2
    check
    proj="node"
    site="groups."
    gotodo
    ;;
  m|t|p)
    proj="project"
    site=""
    nid=$2
    gotodo
    ;;
  a*)
    proj="api/search/${1:1}"
    site="api."
    nid=$2
    gotodo
    ;;
  *)
    nid=$1
    site=""
    if check; then
      proj="node"
    else
      proj="project"
    fi
    gotodo
    ;;
esac

exit 0
