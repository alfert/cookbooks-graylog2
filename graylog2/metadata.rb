maintainer        "Medidata Solutions Inc."
maintainer_email  "cloudteam@mdsol.com"
license           "Apache 2.0"
description       "Installs and configures Graylog2"
version           "0.0.6"
recipe            "graylog2", "Installs and configures Graylog2"

# Only supporting Ubuntu 10.x
supports "ubuntu"

# OpsCode cookbook dependencies
depends "apt"     # http://community.opscode.com/cookbooks/apt
depends "apache2" # http://community.opscode.com/cookbooks/apache2
depends "mongodb" # http://community.opscode.com/cookbooks/mongodb
depends "java"
depends "elasticsearch" # https://github.com/karmi/cookbook-elasticsearch
depends "rvm" # http://community.opscode.com/cookbooks/rvm
depends "rvm_passenger" 
