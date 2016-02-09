#!/bin/sh

test_description="Migration 2 to 3 and 3 to 2 with daemon usage"

. lib/test-lib.sh

test_expect_success "start a docker container" '
	DOCID=$(start_docker)
'

test_install_version "v0.3.10"



test_expect_success "setup iptb nodes" '
	iptb init -n 5 -f --bootstrap=none --port=0
'

test_expect_success "start up iptb nodes" '
    iptb start
'

test_expect_success "check peers works" '
    ipfs swarm peers >peers_out
'

test_expect_success "correct number of peers" '
    test -z "`cat peers_out`"
'




test_install_version "v0.4.0-dev"





test_expect_success "'ipfs-2-to-3 -revert' succeeds" '
	exec_docker "$DOCID" "$GUEST_IPFS_2_TO_3 -verbose -revert -path=/root/.ipfs" >actual
'

test_expect_success "'ipfs-2-to-3 -revert' output looks good" '
	grep "writing keys:" actual ||
	test_fsh cat actual
'

test_install_version "v0.3.10"





test_expect_success "stop docker container" '
	stop_docker "$DOCID"
'

test_done
