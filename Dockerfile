FROM ubi8/ubi:8.3
ARG NEXUS_VERSION
ENV NEXUS_HOME=/opt/nexus
RUN yum install -y --setopt=tsflags=nodocs java-1.8.0-openjdk-devel && yum clean all -y
RUN groupadd -r nexus -f -g 1001
RUN adduser -u 1001 -r -g nexus -m -d ${NEXUS_HOME} \
    -s /sbin/nologin \
    -c "Nexus User" nexus \
    && chown -R nexus:nexus ${NEXUS_HOME} \
    && chmod -R 755 ${NEXUS_HOME}

USER nexus
#RUN tar -xvf nexus-2.14.3-02-bundle.tar.gz ${NEXUS_HOME}/
ADD nexus-2.14.3-02-bundle.tar.gz ${NEXUS_HOME}/
COPY ./nexus-start.sh ${NEXUS_HOME}/
RUN ln -s ${NEXUS_HOME}/nexus-${NEXUS_VERSION} ${NEXUS_HOME}/nexus2
WORKDIR /opt/nexus
VOLUME /opt/nexus/sonatype-work
CMD ["nexus-start.sh"]

