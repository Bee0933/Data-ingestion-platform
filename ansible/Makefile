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

start-metrics: check-host-var
	ansible-playbook ./playbooks/bootsrap_platform_metrics.yaml -l '$(HOSTS)'

start-monitor-server: check-host-var
	ansible-playbook ./playbooks/start_monitor_server.yaml -l '$(HOSTS)'

start-src-server: check-host-var
	ansible-playbook ./playbooks/start_src_server.yaml -l '$(HOSTS)'

start-airbyte-server: check-host-var
	ansible-playbook ./playbooks/start_airbyte_server.yaml -l '$(HOSTS)'

start-storage-server: check-host-var
	ansible-playbook ./playbooks/start_storage_server.yaml -l '$(HOSTS)'

start-query-server: check-host-var
	ansible-playbook ./playbooks/start_query_server.yaml -l '$(HOSTS)'

start-rev-proxy: check-host-var
	ansible-playbook ./playbooks/start_reverse_proxy.yaml -l '$(HOSTS)'

start-dbt-transform: check-host-var
	ansible-playbook ./playbooks/start_dbt_transform.yaml -l '$(HOSTS)'


# order command 
order:
	@echo "bootstrap-server --> start-src-server --> start-storage-server --> start-airbyte-server --> start-query-server --> start-monitor-server --> start-metrics"
	

# Help command
help:
	@echo "This Makefile provides commands to set up and manage the data platform servers using Ansible playbooks."
	@echo "Please set the HOSTS variable when calling any commands that target specific hosts available in hosts.ini."
	@echo 
	@echo "Available commands:"
	@echo "  make install-requirements     		[Install Ansible dependencies]"
	@echo "  make bootstrap-server HOSTS=<target_hosts>      [Bootstrap the server with initial setup and default packages]"
	@echo "  make bootstrap-metrics HOSTS=<target_hosts>     [Bootstrap the platform nodes with metrics services]"
	@echo "  make start-monitor-server HOSTS=<target_hosts>  [Start the monitoring server]"
	@echo "  make start-src-server HOSTS=<target_hosts>      [Start the source server]"
	@echo "  make start-airbyte-server HOSTS=<target_hosts>  [Start the Airbyte server]"
	@echo "  make start-storage-server HOSTS=<target_hosts>  [Start the storage server]"
	@echo "  make start-query-server HOSTS=<target_hosts>    [Start the query server]"
	@echo "  make start-dbt-transform HOSTS=<target_hosts>   [Run & build DBT models]"
	@echo
	@echo "Usage example:"
	@echo "  make bootstrap-server HOSTS=src-server-0"
	@echo
	@echo
	@echo "check Playbook order:"
	@echo "  make order 				          [check playbook run order]"