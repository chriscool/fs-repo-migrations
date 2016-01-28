#!/bin/sh

test_description="Migration 2 to 3 and 3 to 2 with pins"

. lib/test-lib.sh

test_expect_success "start a docker container" '
	DOCID=$(start_docker)
'

test_install_version "v0.3.10"

test_expect_success "'ipfs init' succeeds" '
	exec_docker "$DOCID" "IPFS_PATH=/root/.ipfs BITS=2048 ipfs init" >actual 2>&1 ||
	test_fsh cat actual
'

test_expect_success ".ipfs/ has been created" '
	exec_docker "$DOCID" "test -d  /root/.ipfs && test -f /root/.ipfs/config"
	exec_docker "$DOCID" "test -d  /root/.ipfs/datastore && test -d /root/.ipfs/blocks"
'

test_expect_success "generate 2 600 kB files and 2 MB file using go-random" '
    exec_docker "$DOCID" "$GUEST_RANDOM 600k 41 >600k1" &&
    exec_docker "$DOCID" "$GUEST_RANDOM 600k 42 >600k2" &&
    exec_docker "$DOCID" "$GUEST_RANDOM 2M 43 >2M"
'




test_expect_success "'fs-repo-migrations -y' works" '
	exec_docker "$DOCID" "$GUEST_FS_REPO_MIG -y" >actual
'

test_expect_success "'fs-repo-migrations -y' output looks good" '
	grep "Migration 2 to 3 succeeded" actual ||
	test_fsh cat actual
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
