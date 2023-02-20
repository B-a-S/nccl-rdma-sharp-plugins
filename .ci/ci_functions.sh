function configure () {
    rm -rf $NFS_WORKSPACE
    rm -rf ./nccl-rdma-sharp-plugins
    cd $NFS_WORKSPACE_ROOT
    git clone git@github.com:Mellanox/nccl-rdma-sharp-plugins.git 

    cp -r ./SRC/.ci ./nccl-rdma-sharp-plugins/
    rm -rf ./nccl-rdma-sharp-plugins/.ci/cfg/*

    mkdir -p ./nccl-rdma-sharp-plugins/.ci/cfg/$HOST1/sharp_conf
    mkdir -p ./nccl-rdma-sharp-plugins/.ci/cfg/$HOST2/sharp_conf

    printf "$HOST1\n$HOST2\n">./nccl-rdma-sharp-plugins/.ci/cfg/$HOST1/hostfile
    printf "log_verbosity 5\n">./nccl-rdma-sharp-plugins/.ci/cfg/$HOST1/sharp_conf/sharp_am.cfg
    printf "log_verbosity 5\n">./nccl-rdma-sharp-plugins/.ci/cfg/$HOST1/sharp_conf/sharpd.cfg
    printf "$SHARP_AM_HOST\n">./nccl-rdma-sharp-plugins/.ci/cfg/$HOST1/sharp_conf/sharp_am_node.txt

    printf "$HOST1\n$HOST2\n">./nccl-rdma-sharp-plugins/.ci/cfg/$HOST2/hostfile
    printf "log_verbosity 5\n">./nccl-rdma-sharp-plugins/.ci/cfg/$HOST2/sharp_conf/sharp_am.cfg
    printf "log_verbosity 5\n">./nccl-rdma-sharp-plugins/.ci/cfg/$HOST2/sharp_conf/sharpd.cfg
    printf "$SHARP_AM_HOST\n">./nccl-rdma-sharp-plugins/.ci/cfg/$HOST2/sharp_conf/sharp_am_node.txt
}

function build () {

    echo "Running build_nccl_rdma_sharp_plugins.sh..."

    ${WORKSPACE}/.ci/build_nccl_rdma_sharp_plugins.sh &> /GIT/build_nccl_rdma_sharp_plugins.log && echo "Build SUCCESFULL !!!" || \
    ( echo "Build FAILED" && tail /GIT/build_nccl_rdma_sharp_plugins.log )
}

function sharp () {
    echo "Running configure_sharp.sh..."

    ${WORKSPACE}/.ci/configure_sharp.sh && echo "Step configure_sharp SUCCESFULL !!!" 
}

function test () {

git clone https://github.com/NVIDIA/nccl-tests.git $NFS_WORKSPACE/nccl-tests

echo "Running run_nccl_tests.sh..."
${WORKSPACE}/.ci/run_nccl_tests.sh && echo  "Tests SUCCESFULL !!!" 
#&& tail /GIT/run_nccl_tests.log ) || \
#    (echo "Tests FAILED" && tail /GIT/run_nccl_tests.log )
}