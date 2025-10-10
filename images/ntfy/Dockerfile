FROM binwiederhier/ntfy:latest

ARG TZ=Etc/UTC
ENV TZ=${TZ}

COPY server.yml /etc/ntfy/ntfy/server.yml

HEALTHCHECK --interval=60s --timeout=10s --start-period=40s --retries=3 CMD \
  sh -c 'wget -q --tries=1 http://localhost:80/v1/health -O - | grep -Eo "\"healthy\"\\s*:\\s*true" || exit 1'

ENTRYPOINT ["ntfy", "serve"]
