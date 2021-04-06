# Container image that runs your code
FROM guff666/docker-multimarkdown-6:latest
RUN git clone https://github.com/hmngwy/jenny.git /tmp/jenny
RUN (cd /tmp/jenny; make install)

WORKDIR /blog
RUN mkdir .dist
ENTRYPOINT ["jenny"]
