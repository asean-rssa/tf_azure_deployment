#!/bin/bash

if [ $(whoami) != root ]; then
    echo "ERROR: You need to run the script as user root or add sudo before command."
    exit 1
fi

# update and upgrade
apt-get -y update
apt-get -y upgrade
sudo apt install openjdk-11-jre-headless -y

# create directory to hold trino server configs
mkdir -p /home/trino-data
wget -N https://repo1.maven.org/maven2/io/trino/trino-server/377/trino-server-377.tar.gz
tar -xvf trino-server-377.tar.gz -C /home
trino_server_dir="/home/trino-server-377/etc"
mkdir -p $trino_server_dir

# create config files for trino server
cat >$trino_server_dir/node.properties <<EOF
node.environment=demo
node.id=ffffffff-ffff-ffff-ffff-ffffffffffff
node.data-dir=/home/trino-data
EOF

cat >$trino_server_dir/jvm.config <<EOF
-server
-Xmx8G
-XX:-UseBiasedLocking
-XX:+UseG1GC
-XX:G1HeapRegionSize=32M
-XX:+ExplicitGCInvokesConcurrent
-XX:+ExitOnOutOfMemoryError
-XX:+HeapDumpOnOutOfMemoryError
-XX:-OmitStackTraceInFastThrow
-XX:ReservedCodeCacheSize=512M
-XX:PerMethodRecompilationCutoff=10000
-XX:PerBytecodeRecompilationCutoff=10000
-Djdk.attach.allowAttachSelf=true
-Djdk.nio.maxCachedBufferSize=2000000
EOF

cat >$trino_server_dir/config.properties <<EOF
coordinator=true
node-scheduler.include-coordinator=true
http-server.http.port=8080
query.max-memory=5GB
query.max-memory-per-node=1GB
discovery.uri=http://localhost:8080
EOF

cat >$trino_server_dir/log.properties <<EOF
io.trino=INFO
EOF

mkdir -p $trino_server_dir/catalog
wget -N https://repo1.maven.org/maven2/io/trino/trino-cli/377/trino-cli-377-executable.jar

mv trino-cli-377-executable.jar trino
chmod +x trino

cat >$trino_server_dir/catalog/delta.properties <<EOF
connector.name=delta-lake
hive.metastore.uri=thrift://hn0-hdi.cb2p0n3k13iernbkm2wxgtv3uh.zqzx.internal.chinacloudapp.cn:9083
hive.azure.abfs-storage-account=025e90a0a55897c0
hive.azure.abfs-access-key=youradlsaccesskey
EOF
