FROM --platform=$BUILDPLATFORM ghcr.io/open-webui/open-webui:${WEBUI_DOCKER_TAG-main}
RUN pip install azure-cli
CMD [ "bash", "start.sh"]
