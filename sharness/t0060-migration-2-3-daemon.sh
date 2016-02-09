#!/bin/sh

test_description="Migration 2 to 3 and 3 to 2 with daemon usage"

. lib/test-lib.sh

test_expect_success "start a docker container" '
	DOCID=$(start_docker)
'

test_install_version "v0.3.10"





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
