FROM node:18-alpine

ARG N8N_VERSION=1.56.1

RUN apk add --update graphicsmagick tzdata

USER root

RUN npm config set prefix '/root/.npm-global'

RUN apk --update add --virtual build-dependencies python3 build-base && \
    npm_config_user=root npm install --location=global n8n@${N8N_VERSION} && \
    apk del build-dependencies

# Adicione esta linha para limpar o cache do npm
RUN npm cache clean --force

ENV PATH="/root/.npm-global/bin:${PATH}"

WORKDIR /data

EXPOSE $PORT

ENV N8N_USER_ID=root

CMD sh -c "echo 'PATH is: $PATH' && ls -l /root/.npm-global/bin && export N8N_PORT=$PORT && n8n start"
