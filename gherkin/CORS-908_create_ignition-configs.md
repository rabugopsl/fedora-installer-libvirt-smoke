*Feature:* Create ignition configs for _Libvirt_ installation.
  In order to install an _Openshift Cluster_, some initial settings are required.
  As an Openshift Installer User
  I want to create the assets required to start the cluster installation.

  *Scenario:*  the user does not supply any additional parameters and there is no previous execution.
    *Given* no previously generated assets exist
    *When* the user tries to generate the installation ignition assets
    *Then* the process log file is generated in the current directory
    *And* the installation state file is generated in the current directory
    *And* the bootstrap node ignition file is generated in the current directory
    *And* the master node ignition file is generated in the current directory
    *And* the worker node ignition file is generated in the current directory
