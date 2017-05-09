#!/bin/bash
set -e

prj_path=$(cd $(dirname $0); pwd -P)
devops_prj_path="$prj_path/devops"
template_path="$devops_prj_path/template"   
config_path="$devops_prj_path/config"   

syslogng_image=balabit/syslog-ng
syslogng_container=syslog-ng

source $devops_prj_path/base.sh

log_path='/opt/data/syslog-ng'

function run() {
    local args='--restart=always'
    args="$args --net=host"
    args="$args -v $log_path:/var/log"
    # we use host network
    # so this is usless
    # args="$args -p 514:514/udp -p 601:601/tcp"
    args="$args -v $config_path/syslog-ng.conf:/etc/syslog-ng/conf.d/syslog-ng.conf"
    run_cmd "docker run -d $args --name $syslogng_container $syslogng_image"
}

function stop() {
    stop_container $syslogng_container
}

function restart() {
    stop
    run
}

help() {
cat <<EOF
    Usage: manage.sh [options]

        run
        stop
        restart
EOF
}

ALL_COMMANDS=""
ALL_COMMANDS="$ALL_COMMANDS run stop restart"

list_contains ALL_COMMANDS "$action" || action=help
$action "$@"
