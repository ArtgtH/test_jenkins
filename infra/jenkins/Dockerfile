FROM jenkins/inbound-agent:latest

USER root

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    python3-venv \
    build-essential \
    libssl-dev \
    libffi-dev \
    python3-dev

RUN curl -fsSL https://download.docker.com/linux/static/stable/x86_64/docker-24.0.7.tgz -o docker.tgz && \
    tar xzvf docker.tgz --strip 1 -C /usr/local/bin docker/docker && \
    rm docker.tgz

ARG DOCKER_GID=984

RUN groupadd -g ${DOCKER_GID} docker && \
    usermod -aG docker jenkins

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.16/gosu-$(dpkg --print-architecture)" \
    && chmod +x /usr/local/bin/gosu

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
CMD ["jenkins-agent"]