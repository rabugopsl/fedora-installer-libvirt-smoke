*Feature:* Create ignition configs for _Libvirt_ installation.
  In order to install an _Openshift Cluster_, some initial settings are required.
  As an Openshift Installer User
  I want to create the assets required to start the cluster installation.


  *Scenario:*  the user does not supply any additional parameters and there are _no remnants_ from a previous execution in the current directory.
    *Given* no previously generated assets exist
    *When* the user tries to generate the installation ignition assets
    *Then* the process log file (_.openshift_install.log_) is generated with the appropriate structure in the current directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the current directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the current directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the current directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the current directory


  *Scenario:*  the user does not supply any additional parameters and there are _existing remnants_ from a previous execution in the current directory.
    *Given* that previously generated assets exist
    *When* the user tries to generate the installation ignition assets
    *Then* the user is informed that the existing assets are being consumed
    *And* the process log file (_.openshift_install.log_) is updated with the new ignition run and the appropriate structure in the current directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the current directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the current directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the current directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the current directory


  *Scenario:*  the user supplies the _--dir_ parameter for a _non existing directory_ and there are _no remnants_ from a previous execution in the specified directory.
    *Given* that the specified directory does not exist
    *When* the user tries to generate the installation ignition assets
    *Then* the specified directory is created
    *And* the process log file (_.openshift_install.log_) is generated with the appropriate structure in the specified directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the specified directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the specified directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the current directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the current directory


  *Scenario:*  the user supplies the _--dir_ parameter for an _existing directory_ and there are _no remnants_ from a previous execution in the specified directory.
    *Given* that the specified directory exists and no previously generated assets exist in that directory
    *When* the user tries to generate the installation ignition assets
    *Then* the process log file (_.openshift_install.log_) is generated with the appropriate structure in the specified directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the specified directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the specified directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the specified directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the specified directory


  *Scenario:*  the user supplies the _--dir_ parameter for an _existing directory_ and there are _existing remnants_ from a previous execution in the specified directory.
    *Given* that the specified directory exists and previously generated assets exist
    *When* the user tries to generate the installation ignition assets
    *Then* the user is informed that the existing assets are being consumed
    *And* the process log file (_.openshift_install.log_) is updated with the new ignition run and the appropriate structure in the specified directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the specified directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the specified directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the specified directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the specified directory


  *Scenario:*  the user supplies the _--log-level_ parameter to _debug_ and there are _no remnants_ from a previous execution in the current directory.
    *Given* no previously generated assets exist
    *When* the user tries to generate the installation ignition assets
    *Then* the user is informed of all debug level entries in the log
    *And* the process log file (_.openshift_install.log_) is generated with the appropriate structure in the current directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the current directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the current directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the current directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the current directory


  *Scenario:*  the user supplies the _--dir_ parameter for a _non existing directory_, as well as defining the  _--log-level_ parameter to _debug_ and there are _no remnants_ from a previous execution in the specified directory.
    *Given* that the specified directory does not exist
    *When* the user tries to generate the installation ignition assets
    *Then* the user is informed of all debug level entries in the log
    *And* the specified directory is created
    *And* the process log file (_.openshift_install.log_) is generated with the appropriate structure in the specified directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the specified directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the specified directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the current directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the current directory


  *Scenario:*  the user supplies the _--dir_ parameter for an _existing directory_, as well as defining the  _--log-level_ parameter to _debug_ and there are _no remnants_ from a previous execution in the specified directory.
    *Given* that the specified directory exists and no previously generated assets exist in that directory
    *When* the user tries to generate the installation ignition assets
    *Then* the user is informed of all debug level entries in the log
    *And* the process log file (_.openshift_install.log_) is generated with the appropriate structure in the specified directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the specified directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the specified directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the specified directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the specified directory


  *Scenario:*  the user supplies the _--dir_ parameter for an _existing directory_, as well as defining the  _--log-level_ parameter to _debug_ and there are _existing remnants_ from a previous execution in the specified directory.
    *Given* that the specified directory exists and previously generated assets exist
    *When* the user tries to generate the installation ignition assets
    *Then* the user is informed that the existing assets are being consumed
    *And* the user is informed of all debug level entries in the log
    *And* the process log file (_.openshift_install.log_) is updated with the new ignition run and the appropriate structure in the specified directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the specified directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the specified directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the specified directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the specified directory


  *Scenario:*  the user supplies the _--dir_ parameter for an _existing directory_, as well as defining the  _--log-level_ parameter to _info_ and there are _existing remnants_ from a previous execution in the specified directory.
    *Given* that the specified directory exists and previously generated assets exist
    *When* the user tries to generate the installation ignition assets
    *Then* the user is informed that the existing assets are being consumed
    *And* the user is informed of all info level entries in the log
    *And* the process log file (_.openshift_install.log_) is updated with the new ignition run and the appropriate structure in the specified directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the specified directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the specified directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the specified directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the specified directory


  *Scenario:*  the user supplies the _--dir_ parameter for an _existing directory_, as well as defining the  _--log-level_ parameter to _warn_ and there are _existing remnants_ from a previous execution in the specified directory.
    *Given* that the specified directory exists and previously generated assets exist
    *When* the user tries to generate the installation ignition assets
    *Then* the user is informed that the existing assets are being consumed
    *And* the user is informed of all warning level entries in the log
    *And* the process log file (_.openshift_install.log_) is updated with the new ignition run and the appropriate structure in the specified directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the specified directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the specified directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the specified directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the specified directory


  *Scenario:*  the user supplies the _--dir_ parameter for an _existing directory_, as well as defining the  _--log-level_ parameter to _error_ and there are _existing remnants_ from a previous execution in the specified directory.
    *Given* that the specified directory exists and previously generated assets exist
    *When* the user tries to generate the installation ignition assets
    *Then* the user is informed that the existing assets are being consumed
    *And* the user is informed of all error level entries in the log
    *And* the process log file (_.openshift_install.log_) is updated with the new ignition run and the appropriate structure in the specified directory
    *And* the installation state file (_.openshift_install_state.json_) is generated with the appropriate structure in the specified directory
    *And* the bootstrap node ignition file (_bootstrap.ign_) is generated with the appropriate structure in the specified directory
    *And* the master node ignition file (_master.ign_) is generated with the appropriate structure in the specified directory
    *And* the worker node ignition file (_worker.ign_)is generated with the appropriate structure in the specified directory


