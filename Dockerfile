FROM dockershelf/python:3.11
LABEL maintainer "Luis Alejandro Martínez Faneyth <luis@luisalejandro.org>"

ARG UID=1000
ARG GID=1000

RUN apt-get update && \
    apt-get install sudo python3.11-venv git make jq

ADD requirements.txt /root/
RUN pip3 install -r /root/requirements.txt
RUN rm -rf /root/requirements.txt

RUN EXISTUSER=$(getent passwd | awk -F':' '$3 == '$UID' {print $1}') && \
    [ -n "${EXISTUSER}" ] && deluser ${EXISTUSER} || true

RUN EXISTGROUP=$(getent group | awk -F':' '$3 == '$GID' {print $1}') && \
    [ -n "${EXISTGROUP}" ] && delgroup ${EXISTGROUP} || true

RUN groupadd -g "${GID}" impress || true
RUN useradd -u "${UID}" -g "${GID}" -ms /bin/bash impress

RUN echo "impress ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/impress

USER impress

RUN mkdir -p /home/impress/app

WORKDIR /home/impress/app

CMD tail -f /dev/null