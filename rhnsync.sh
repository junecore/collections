#!/bin/bash

# This tool can be used to sync down Red Hat based packages from RHN using only Red Hat shipped tools
## Brian "Red Beard" Harrington <brian@dead-city.org> ## 
# To satisfy the pre-reqs for this script install the following two rpms:
# yum install yum-utils createrepo 

# Specify your  Repo that you will share internally 
download_dir="/var/www/html/repo"

/usr/bin/reposync --gpgcheck -qlmn --download-metadata -p ${download_dir}/ >> /var/log/reposync.log 2>&1
## use -d above to delete obselete rpms ( might need if needs to do yum update system ) 

for dirname in `find ${download_dir} -maxdepth 1 -mindepth 1 -type d`; do
  echo $dirname: | tee -a /var/log/reposync.log
	if [ -f "${dirname}/comps.xml" ]; then
		cp ${dirname}/comps.xml ${dirname}/Packages/ >> /var/log/reposync.log 2>&1
		createrepo  --update -p --workers 2 -g ${dirname}/Packages/comps.xml ${dirname} >> /var/log/reposync.log 2>&1
	else
	  # create the comps.xml files 
		createrepo  --update -p --workers 2 ${dirname}/ >> /var/log/reposync.log 2>&1
	fi	
	
	set -o pipefail 
	updateinfo=$(ls -1t  ${dirname}/*-updateinfo.xml.gz 2>/dev/null | head -1 ) 
	if [[ -f $updateinfo  &&  $? -eq 0 ]]; then
		echo "Updating errata information for ${dirname}" >> /var/log/reposync.log 2>&1
		\cp $updateinfo ${dirname}/updateinfo.xml.gz  >> /var/log/reposync.log 2>&1
		gunzip -df ${dirname}/updateinfo.xml.gz  >> /var/log/reposync.log 2>&1
		modifyrepo ${dirname}/updateinfo.xml ${dirname}/repodata/  >> /var/log/reposync.log 2>&1
	else
		echo "No errata information to be processed for ${dirname}" >> /var/log/reposync.log 2>&1
	fi
done
