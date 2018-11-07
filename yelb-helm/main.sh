#!/usr/bin/env bash

install(){
	curl https://raw.githubusercontent.com/helm/helm/master/scripts/get > get_helm.sh
	chmod 700 get_helm.sh
	$ ./get_helm.sh
}

helm_version(){}
helm_list(){}
helm_install(){}
helm_upgrade(){}
helm_rollback(){}
helm_package(){}
helm_delete(){}
helm_status(){}
helm_test(){}




