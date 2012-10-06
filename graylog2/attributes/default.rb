default.graylog2.basedir = "/var/graylog2"
default.graylog2.server.version = "0.9.6p1"
default.graylog2.web_interface.version = "0.9.6p1"

default.graylog2.elasticsearch.version="0.19.2"

default.graylog2.mongodb.host = "localhost"
default.graylog2.mongodb.port = 27017
default.graylog2.mongodb.max_connections = 150
default.graylog2.mongodb.database = "graylog2"
default.graylog2.mongodb.auth = "false"
default.graylog2.mongodb.user = "user"
default.graylog2.mongodb.password = "password"

default.graylog2.port = 514
default.graylog2.collection_size = 50000000
default.graylog2.email = "graylog2@example.org"
default.graylog2.email_package = "postfix"
default.graylog2.allow_deleting = "false"
default.graylog2.send_stream_alarms = true
default.graylog2.send_stream_subscriptions = true
default.graylog2.stream_alarms_cron_minute = "*/15"
default.graylog2.stream_subscriptions_cron_minute = "*/15"

default.graylog2.external_hostname = nil
default.graylog2.server_name = "graylog2"

default['graylog2']['ruby_version'] = "ruby-1.9.3-p194"
default['graylog2']['ruby_string'] = "ruby-1.9.3-p194@passenger"
default['graylog2']['passenger_version'] = "3.0.17"
default['graylog2']['web_path'] = "/var/graylog2/web"
default['graylog2']['web_user'] = "graylog2-web"
default['graylog2']['web_group'] = "graylog2-web"

