FROM stackql/stackql-jupyter-base:latest AS stackql-jupyter
WORKDIR /jupyter
USER root
# copy example notebooks to Jupyter workspace
COPY ./notebooks/* /jupyter
RUN chmod 644 *.ipynb && \
    chown jovyan:users *.ipynb
# create directory for service account keys
RUN mkdir -p /jupyter/.keys
RUN chmod 644 /jupyter/.keys && \
    chown jovyan:users /jupyter/.keys  
# copy config directory
RUN mkdir -p /config
COPY config/ /config/
# copy assets directory
RUN mkdir -p /assets
COPY assets/ /assets/
# copy entrypoint script
RUN mkdir -p /scripts
COPY scripts/ /scripts/
RUN chmod +x /scripts/entrypoint.sh