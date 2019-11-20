# Supported OS Slugs:
# ubuntu16
# ubuntu18
# centos6
# centos7
#
#
#
ARG OS_SLUG="ubuntu1804"
ARG OS_CMD="/lib/systemd/systemd"

ARG DEVSHOP_PLAYBOOK="playbook.server.yml"

FROM geerlingguy/docker-${OS_SLUG}-ansible
USER root

# Copy DevShop source into container.
COPY ./ /usr/share/devshop

# Install galaxy roles
COPY https://raw.githubusercontent.com/geerlingguy/drupal-vm/master/provisioning/requirements.yml /usr/share/devshop/roles/requirements.yml
RUN ansible-galaxy install -r requirements.yml --force

# Run the ansible playbook inside Docker.
RUN ansible-playbook /etc/ansible/devshop/$DEVSHOP_PLAYBOOK \
  # Enable FPM. See https://github.com/geerlingguy/drupal-vm/issues/1366.
  && systemctl enable php7.2-fpm.service

EXPOSE 80 443 3306 8025

CMD ["$OS_CMD"]
