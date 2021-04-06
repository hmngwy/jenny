# Container image that runs your code
FROM guff666/docker-multimarkdown-6:latest
COPY ./ /tmp/jenny
RUN (cd /tmp/jenny; make install)

WORKDIR /blog
RUN mkdir .dist
ENTRYPOINT ["jenny"]
