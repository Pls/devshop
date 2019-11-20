# Supported OS Slugs:
# ubuntu16
# ubuntu18
# centos6
# centos7
#
#
#
ARG OS_SLUG="ubuntu1804"
ARG DEVSHOP_CORE_TAG="latest"

FROM devshop/core-${OS_SLUG}:${DEVSHOP_CORE_TAG}
USER root

ARG OS_CMD="/lib/systemd/systemd"
ENV OS_CMD=$OS_CMD

ARG DEVSHOP_PLAYBOOK="playbook.server.yml"
ENV DEVSHOP_PLAYBOOK ${DEVSHOP_PLAYBOOK:-"xxx"}

ARG DEVSHOP_HOSTNAME="devshop.local.computer"
ENV DEVSHOP_HOSTNAME=$DEVSHOP_HOSTNAME

RUN echo "Preparing container using Ansible Playbook ${DEVSHOP_PLAYBOOK}:"
RUN cat /usr/share/devshop/roles/${DEVSHOP_PLAYBOOK}

# Run the ansible playbook inside Docker.
RUN echo "Running Playbook: /usr/share/devshop/roles/${DEVSHOP_PLAYBOOK}"
RUN ansible-playbook  /usr/share/devshop/roles/${DEVSHOP_PLAYBOOK} --extra-vars="server_hostname=${DEVSHOP_HOSTNAME}"

EXPOSE 80 443 3306 8025

CMD ["$OS_CMD"]
