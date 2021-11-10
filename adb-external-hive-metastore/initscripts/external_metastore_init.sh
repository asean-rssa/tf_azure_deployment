#!/bin/bash
# This is an extra init script for stable release client data clusters in the dev Databricks workspace.
# It lives at dbfs:/scripts/external_metastore_init.sh
# Configure spark settings for shared interactive clusters
cat <<'EOF' >/databricks/driver/conf/00-custom-spark.conf
[driver] {
    # Hive specific configuration options.
    # spark.hadoop prefix is added to make sure these Hive specific options will propagate to the metastore client.
    "spark.hadoop.javax.jdo.option.ConnectionURL" = "{{secrets/hive/HIVE-URL}}"
    "spark.hadoop.javax.jdo.option.ConnectionUserName" = "{{secrets/hive/HIVE-USER}}"
    "spark.hadoop.javax.jdo.option.ConnectionPassword" = "{{secrets/hive/HIVE-PASSWORD}}"
    "spark.hadoop.javax.jdo.option.ConnectionDriverName" = "com.microsoft.sqlserver.jdbc.SQLServerDriver"
    "spark.sql.hive.metastore.version" = "3.1.0"
    "spark.sql.hive.metastore.jars" = "/dbfs/tmp/hive/3-1-0/lib/*"
    "spark.hadoop.metastore.catalog.default" = "hive"
    "spark.databricks.delta.preview.enabled" = "true"
    "datanucleus.fixedDatastore" = "true"
    "datanucleus.autoCreateSchema" = "false"
    }
EOF
