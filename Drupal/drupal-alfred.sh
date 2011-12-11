DRUSH_PATH="/usr/local/bin/drush"

#arg handling in alfred sucks, lets split it up
#query="{query}"
#IFS=" "
#set -- $query

proj=''
site=''

# kind of a hack here to test if we're testing so we can do string comparisions.
if [ -n "${ROUNDUP_VERSION+1}"] ; then
  command=open
else
  command=echo
fi

gotodo() {
  $command "http://${site}drupal.org/${proj}/${nid}"
}

check() {
  if [[ "$nid" =~ ^[0-9]+$ ]] ; then
    return 0
  else
    return 1
  fi
}

help() {
    cat <<EOF
USAGE: Invoke Alfred
d [dsogmtpua] [expression]

DESCRIPTION
d - drush (requires site aliases)
s - search Drupal.org
o - open (requires site aliases)
g - open a node on groups.drupal.org
m|t|p - open a module, theme or project page on Drupal.org
u - open a user page on Drupal.org
a6 - open an api page on Drupal.org for Drupal 6
a7 - open an api page on Drupal.org for Drupal 7
no arg - makes a best guess if you want a node or a project on Drupal.org

EOF
}

case "$1" in
  d)
    shift
    ${DRUSH_PATH} $@
    ;;
  o)
    shift
    uri=$(${DRUSH_PATH} $@ status | grep 'Site URI' | tr -d ' ' | tr -d '\r')
    if [ $uri ] ; then
      $command "http://${uri:8}"
    else
      echo "Invalid alias: $1"
    fi
    ;;
  s)
    proj="search/apachesolr_multisitesearch"
    nid=$2
    gotodo
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
  u)
    $command http://dgo.to/@${2}
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
    if [$nid == ''] ; then
     help
     exit
    fi
    if check; then
      proj="node"
    else
      proj="project"
    fi
    gotodo
    ;;
esac

exit 0
