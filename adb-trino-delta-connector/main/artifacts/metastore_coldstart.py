# Databricks notebook source
# MAGIC %md
# MAGIC
# MAGIC - Hive JDBC URL
# MAGIC `jdbc:sqlserver://bk-sqlserver.database.windows.net:1433;database=hive3;user=abc@bk-sqlserver;password={your_password_here};encrypt=true;trustServerCertificate=false;hostNameInCertificate=*.database.windows.net;loginTimeout=30;`

# COMMAND ----------

# DBTITLE 1,Download hive and hadoop tools lib
# MAGIC %sh
# MAGIC wget https://archive.apache.org/dist/hadoop/common/hadoop-2.7.2/hadoop-2.7.2.tar.gz
# MAGIC tar -xvzf hadoop-2.7.2.tar.gz --directory /opt
# MAGIC wget https://archive.apache.org/dist/hive/hive-3.1.0/apache-hive-3.1.0-bin.tar.gz
# MAGIC tar -xvzf apache-hive-3.1.0-bin.tar.gz --directory /opt
# MAGIC ## https://www.microsoft.com/en-us/download/details.aspx?id=11774
# MAGIC wget https://download.microsoft.com/download/0/2/A/02AAE597-3865-456C-AE7F-613F99F850A8/sqljdbc_6.0.8112.200_enu.tar.gz
# MAGIC tar -xvzf sqljdbc_6.0.8112.200_enu.tar.gz --directory /opt
# MAGIC cp /opt/sqljdbc_6.0/enu/jre8/sqljdbc42.jar /opt/apache-hive-3.1.0-bin/lib/sqljdbc42.jar

# COMMAND ----------

# MAGIC %sh
# MAGIC mkdir -p /dbfs/tmp/hive/3-1-0/lib/
# MAGIC cp -r /opt/apache-hive-3.1.0-bin/lib/. /dbfs/tmp/hive/3-1-0/lib/
# MAGIC cp -r /opt/hadoop-2.7.2/share/hadoop/common/lib/. /dbfs/tmp/hive/3-1-0/lib/

# COMMAND ----------

# DBTITLE 1,Test Hive Environment Variables - set these vars on cluster UI --> Advance tab
# MAGIC %sh
# MAGIC echo $HIVE_URL
# MAGIC echo $HIVE_USER
# MAGIC echo $HIVE_PASSWORD

# COMMAND ----------

# DBTITLE 1,Initialize hive schema
# MAGIC %sh
# MAGIC export HIVE_HOME="/opt/apache-hive-3.1.0-bin"
# MAGIC export HADOOP_HOME="/opt/hadoop-2.7.2"
# MAGIC export SQLDB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver"
# MAGIC
# MAGIC # uncomment following line to init schema
# MAGIC /opt/apache-hive-3.1.0-bin/bin/schematool -dbType mssql -url $HIVE_URL -passWord $HIVE_PASSWORD -userName $HIVE_USER -driver $SQLDB_DRIVER -initSchema

# COMMAND ----------

# MAGIC %sh
# MAGIC # validate that schema is initialized
# MAGIC /opt/apache-hive-3.1.0-bin/bin/schematool -dbType mssql -url $HIVE_URL -passWord $HIVE_PASSWORD -userName $HIVE_USER -driver $SQLDB_DRIVER -info

# COMMAND ----------

# DBTITLE 1,Validate hive is initialized
# MAGIC %sh
# MAGIC export HIVE_HOME="/opt/apache-hive-3.1.0-bin"
# MAGIC export HADOOP_HOME="/opt/hadoop-2.7.2"
# MAGIC export SQLDB_DRIVER="com.microsoft.sqlserver.jdbc.SQLServerDriver"
# MAGIC
# MAGIC /opt/apache-hive-3.1.0-bin/bin/schematool -dbType mssql -url $HIVE_URL -passWord $HIVE_PASSWORD -userName $HIVE_USER -driver $SQLDB_DRIVER -info

# COMMAND ----------

# MAGIC %sql
# MAGIC show databases;
