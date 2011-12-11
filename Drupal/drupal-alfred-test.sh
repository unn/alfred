#!/usr/bin/env roundup

describe "Drupal Alfred tests"

da="./drupal-alfred.sh"

it_shows_help_with_no_arg() {
  $da | grep USAGE
}


# tests for * of switch
it_goes_to_views_with_no_main_arg() {
  data="views"
  command="$($da $data)"
  test $command = "http://drupal.org/project/views"
}

it_goes_to_nid_with_no_main_arg() {
  data="1246820"
  command="$($da $data)"
  test $command = "http://drupal.org/node/1246820"
}

# test search
it_goes_to_search() {
  data="s webchick"
  command="$($da $data)"
  test $command = "http://drupal.org/search/apachesolr_multisitesearch/webchick"
}

# test g.d.o
it_goes_to_gdo() {
  data="g 25"
  command="$($da $data)"
  test $command = "http://groups.drupal.org/node/25"
}

# test project|module|theme
it_goes_to_project() {
  data="p views"
  command="$($da $data)"
  test $command = "http://drupal.org/project/views"
}

# test project|module|theme
it_goes_to_module() {
  data="m views"
  command="$($da $data)"
  test $command = "http://drupal.org/project/views"
}

# test project|module|theme
it_goes_to_theme() {
  data="t zen"
  command="$($da $data)"
  test $command = "http://drupal.org/project/zen"
}

# test user
it_goes_to_user() {
  data="u dstol"
  command="$($da $data)"
  test $command = "http://dgo.to/@dstol"
}

# test user with a curl
it_goes_to_user_curl() {
  data="u dstol"
  command="$($da $data)"
  userpath=$(curl -sI ${command} | grep Location | awk '{print $2}')
  test $userpath = $'http://drupal.org/user/329570\r'
}

# drupal 6 api test
it_goes_to_d6_api() {
  data="a6 hook_menu"
  command="$($da $data)"
  test $command = "http://api.drupal.org/api/search/6/hook_menu"
}

# drupal 6 api test --- d.o was throwing a 500 here
#it_goes_to_d6_api_with_curl() {
#  data="a6 hook_menu"
#  command="$($da $data)"
#  userpath=$(curl -sI ${command} | grep Location | awk '{print $2}')
#  test $userpath = $'http://drupal.org/user/329570\r'
#}

# drupal 7 api test
it_goes_to_d7_api() {
  data="a7 hook_menu"
  command="$($da $data)"
  test $command = "http://api.drupal.org/api/search/7/hook_menu"
}

# drush tests
