SHELL=/bin/bash

#check if HOST var is set
define HOSTS_ERROR_MSG
HOSTS variable is not set.
endef

check-host-var:
    ifndef HOSTS
	$(error $(HOSTS_ERROR_MSG))
    endif


install-requirements:
	ansible-galaxy install --force -r requirements.yml

bootstrap-server: check-host-var
	ansible-playbook ./playbooks/initial_bootstrap.yaml -l '$(HOSTS)' &&\
			ansible-playbook ./playbooks/default_pakages.yaml -l '$(HOSTS)'

start-src-server: check-host-var
	ansible-playbook ./playbooks/start_src_server.yaml -l '$(HOSTS)'

start-airbyte-server: check-host-var
	ansible-playbook ./playbooks/start_airbyte_server.yaml -l '$(HOSTS)'

start-storage-server: check-host-var
	ansible-playbook ./playbooks/start_storage_server.yaml -l '$(HOSTS)'


# Help command
help:
	@echo "This Makefile provides commands to set up and manage the data platform servers using Ansible playbooks."
	@echo "Please set the HOSTS variable when calling any commands that target specific hosts available in hosts.ini."
	@echo 
	@echo "Available commands:"
	@echo "  make install-requirements     		[Install Ansible dependencies]"
	@echo "  make bootstrap-server HOSTS=<target_hosts>      [Bootstrap the server with initial setup and default packages]"
	@echo "  make start-src-server HOSTS=<target_hosts>      [Start the source server]"
	@echo "  make start-airbyte-server HOSTS=<target_hosts>  [Start the Airbyte server]"
	@echo "  make start-storage-server HOSTS=<target_hosts>  [Start the storage server]"
	@echo
	@echo "Usage example:"
	@echo "  make bootstrap-server HOSTS=src-server-0"