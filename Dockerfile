ARG UBUNTU_OS_RELEASE
FROM ubuntu:${UBUNTU_OS_RELEASE}
SHELL ["/bin/bash", "-c"]
RUN apt-get update && apt-get install -y lsb-release sudo less policykit-1 software-properties-common kmod libusb-1.0-0
RUN apt-get update && apt-get install -y apt-utils debconf-utils dialog
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN echo "resolvconf resolvconf/linkify-resolvconf boolean false" | debconf-set-selections
RUN apt-get update && apt-get install -y resolvconf
RUN apt-get install -y iputils-ping iproute2 netcat iptables dnsutils network-manager usbutils net-tools
ARG UBUNTU_OS_RELEASE
RUN if [[ ${UBUNTU_OS_RELEASE} == "18.04" || ${UBUNTU_OS_RELEASE} == "20.04" ]]; then echo UBUNTU_OS_RELEASE: ${UBUNTU_OS_RELEASE}; apt-get install -y python; else echo UBUNTU_OS_RELEASE: {UBUNTU_OS_RELEASE};fi
RUN apt-get install -y python3-yaml dosfstools libgetopt-complete-perl openssh-client binutils xxd
RUN apt-get install -y cpio udev dmidecode
ARG SDKM_CLIENT
RUN echo ${SDKM_CLIENT}
COPY ./${SDKM_CLIENT} /tmp/
RUN apt-get install -y /tmp/sdkmanager_*.deb
RUN rm /tmp/sdkmanager_*.deb
COPY ./docker-entrypoint.sh /usr/local/bin/
RUN chmod 0755 /usr/local/bin/docker-entrypoint.sh
RUN bash -c 'echo "%sudo ALL=NOPASSWD: ALL" >> /etc/sudoers.d/password_bypass_sudo_file'
RUN apt-get update && apt-get upgrade -y
SHELL ["/bin/sh", "-c"]
RUN useradd -d /home/nvidia -m -s /bin/bash -g root -G sudo nvidia
RUN echo "nvidia\nnvidia" | passwd nvidia
USER nvidia
WORKDIR /home/nvidia
ENTRYPOINT ["docker-entrypoint.sh"]
SHELL ["/bin/bash", "-c"]
CMD ["sdkmanager"]
