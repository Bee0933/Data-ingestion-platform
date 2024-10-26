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

