#!/bin/bash
log_n() {
    echo -n "$(date '+%FT%T%z') $@"
}

launch_CrushFTP() {
    log_n "Starting CrushFTP... "
     if [[ -z "$JAVA_OPTIONS" ]] ; then
        JAVA_OPTIONS="-Xmx512m"
    fi
    java $JAVA_OPTIONS -DdataSource.url=$DATASOURCE_URL -DdataSource.user=$DATASOURCE_USER -DdataSource.password=$DATASOURCE_PASSWORD -DdataSource.driverClass=$DATASOURCE_DRIVERCLASS -Ddatasource.maxWait=$DATASOURCE_MAXWAIT -Ddatasource.poolSize=$DATASOURCE_POOLSIZE -Ddatasource.autocommit=$DATASOURCE_AUTOCOMMIT -Dhibernate.dialect=$HIBERNATE_DIALECT -Dhibernate.show_sql=$HIBERNATE_SHOW_SQL -Dhibernate.use_jdbc_metadata_defaults=$HIBERNATE_USE_JDBC_METADATA_DEFAULTS -Dbroker.trustedPackages=$BROKER_TRUSTEDPACKAGES -Dbroker.url=$BROKER_URL -DstorageBasePath=$STORAGEBASEPATH -DlogInboundPath=$LOGINBOUNDPATH -jar CrushFTP.jar -d & >/dev/null 2>&1
    echo OK
}

# Create default admin user
if [ -z "$ADMIN_USER" ]; then
    ADMIN_USER=crushadmin
fi

if [[ ! -d "users/MainUsers/$ADMIN_USER" ]] || [[ ! -f admin_user_set ]] ; then
    log_n "Creating admin user $ADMIN_USER..."

    if [[ -z "$ADMIN_PASSWORD" ]] ; then
        ADMIN_PASSWORD=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 16 | head -n 1)
    fi

    log_n "" 
    java -jar CrushFTP.jar -a "$ADMIN_USER" "$ADMIN_PASSWORD"
    touch admin_user_set
else
    ADMIN_PASSWORD="****************"
fi
# End 

launch_CrushFTP

log_n "Waiting server starting..."

until [ -f prefs.XML ]
do
    sleep 1
done

echo -e "\n########################################"
echo "# Started:    $(date '+%FT%T%z')"
echo "# User:       $ADMIN_USER"
echo "# Password:   $ADMIN_PASSWORD"
echo "########################################"

until [ -f CrushFTP.log ]
do
    sleep 1
done

tail -f CrushFTP.log