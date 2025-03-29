# DOcker file is use to create an image is like blue print of the whole project 
# Base image: ubuntu:22.04
FROM ubuntu:22.04

# ARGs
# https://docs.docker.com/engine/reference/builder/#understand-how-arg-and-from-interact
ARG TARGETPLATFORM=linux/amd64,linux/arm64
ARG DEBIAN_FRONTEND=noninteractive

# neo4j 5.5.0 installation and some cleanup
RUN apt-get update && \
    apt-get install -y git wget gnupg software-properties-common && \
    wget -O - https://debian.neo4j.com/neotechnology.gpg.key | apt-key add - && \
    echo 'deb https://debian.neo4j.com stable latest' > /etc/apt/sources.list.d/neo4j.list && \
    add-apt-repository universe && \
    apt-get update && \
    apt-get install -y nano unzip neo4j python3-pip && \
    apt-get autoremove -y && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# TODO: Complete the Dockerfile
# Installing necessary packages pandas , pyarrow , neo4j 
RUN pip3 install --upgrade pip && \
    pip3 install neo4j pandas pyarrow
#acessing the given .parquet file 
RUN wget -O yellow_tripdata_2022-03.parquet https://d37ci6vzurychx.cloudfront.net/trip-data/yellow_tripdata_2022-03.parquet
# Uploaded data_loader file in git hub and giving access to the token as that is a priavte repository 
RUN git clone https://x-access-token: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@github.com/SP-2025-CSE511-Data-Processing-at-Scale/Project-1-sagar158.git /cse511
#configuring ne04j
RUN echo "dbms.security.auth_enabled=false" >> /etc/neo4j/neo4j.conf && \
    echo "dbms.default_listen_address=0.0.0.0" >> /etc/neo4j/neo4j.conf && \
    echo "dbms.connector.bolt.listen_address=0.0.0.0:7687" >> /etc/neo4j/neo4j.conf && \
    echo "dbms.connector.http.listen_address=0.0.0.0:7474" >> /etc/neo4j/neo4j.conf
#setting Id password for neo4j    
RUN neo4j-admin dbms set-initial-password project1phase1
#download , install plugin .jar file will be installed
RUN wget -O /tmp/neo4j-graph-data-science-2.15.0.zip \
    https://graphdatascience.ninja/neo4j-graph-data-science-2.15.0.zip && \
    unzip /tmp/neo4j-graph-data-science-2.15.0.zip -d /var/lib/neo4j/plugins/ && \
    rm /tmp/neo4j-graph-data-science-2.15.0.zip

# Ensure Neo4j has access to plugins    
RUN chown -R neo4j:neo4j /var/lib/neo4j/plugins

# Enable security settings for GDS plugin
RUN echo "dbms.security.procedures.unrestricted=gds.*" >> /etc/neo4j/neo4j.conf && \
    echo "dbms.security.procedures.allowlist=gds.*" >> /etc/neo4j/neo4j.conf

#we have commented run beneth code and will only create image and will run the container after
# Run the data loader script
RUN chmod +x /cse511/data_loader.py
    # && \
    # neo4j start && \
    # python3 data_loader.py && \
    # neo4j stop

# Expose neo4j ports
EXPOSE 7474 7687

# Start neo4j service and show the logs on container run
# CMD ["/bin/bash", "-c", "neo4j start && tail -f /dev/null"]
CMD ["/bin/bash", "-c", "neo4j start && sleep 10 && python3 /cse511/data_loader.py && tail -f /dev/null"]
