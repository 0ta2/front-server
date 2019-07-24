#
# Makefile
#

DOCKROPTION := run --rm -it
ENVFILE := ./molecule/shared/.env.yml
CONFIG := ./molecule/docker/molecule.yml
MOUNT1 := "${PWD}":/tmp/$(basename "${PWD}"):ro
MOUNT2 := /var/run/docker.sock:/var/run/docker.sock
WORKDIR := /tmp/$(basename "${PWD}")
DOCKERIMAGE := quay.io/ansible/molecule:2.20.2
MOLECULE := docker $(DOCKROPTION) -v $(MOUNT1) -v $(MOUNT2) -w $(WORKDIR) $(DOCKERIMAGE) molecule --base-config $(CONFIG) --env-file $(ENVFILE)
DEBUG := --no-debug

test:
	@$(MOLECULE) $(DEBUG) test --scenario-name docker

create:
	@$(MOLECULE) $(DEBUG) create --scenario-name docker

converge:
	@$(MOLECULE) $(DEBUG) converge --scenario-name docker

login:
	@$(MOLECULE) $(DEBUG) login --scenario-name docker

verify:
	@$(MOLECULE) $(DEBUG) verify --scenario-name docker
