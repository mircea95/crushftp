ARG REPO=europe-docker.pkg.dev/pj-bu-itops-devops-tools/ag-shared-docker-devopstools-be-prod
ARG RUN_IMG=up/java:ubi8-corretto11-latest

FROM $REPO/$RUN_IMG

# Add aditional tools
USER root
RUN set -eux \
    && yum install wget dos2unix -y \
    && yum clean all

# Download and unzi crushFTP
WORKDIR /var/opt
RUN set -eux \
    && wget https://www.crushftp.com/early10/CrushFTP10.zip \
    && unzip CrushFTP10.zip \
    && rm CrushFTP10.zip

WORKDIR /var/opt/CrushFTP10

RUN mkdir -p ./WebInterface/Preferences/panels/Plugins/CrossnetPersister

COPY CrossnetPersister/ ./WebInterface/Preferences/panels/Plugins/CrossnetPersister/

COPY plugins/CrossnetPersister-1.0.0-20230914.153413-7-jar-with-dependencies.jar ./plugins/CrossnetPersister.jar 

COPY startup.sh ./startup.sh
RUN dos2unix startup.sh

# Change owner to 'root' user and 'appuser' group
# RUN chown -R root:appuser ./ && \
#     # Grant permissions to 'appuser' group
#     chmod -R g+rwx,o-rwx ./
#     # Change owner to 'appuser' user for certain folders
#     # chown -R appuser ./var/log/

# USER appuser
# Expose ports
# HTTP 
EXPOSE 8080
# FTP
EXPOSE 21
# SFTP
EXPOSE 2222

ENTRYPOINT ["./startup.sh"]
# CMD java -Xmx1024m -jar CrushFTP.jar -d