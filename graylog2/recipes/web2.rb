#
# Cookbook Name:: graylog2
# Recipe:: web2
#
# Copyright 2012, Klaus Alfert
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Install required APT packages
package "build-essential"
if node.graylog2.email_package
    package node.graylog2.email_package
end

group node['graylog2']['web_group'] do
  action :create
  system true
end

user node['graylog2']['web_user'] do
  action :create
  home node['graylog2']['basedir']
  gid node['graylog2']['web_group']
  comment "services user for the graylog2-web-interface"
  supports :manage_home => true
  shell "/bin/bash"
  system true
end

# We use chef-rvm to ensure a proper 1.9.3 environemnt

# Install gem dependencies together with chef-rvm (= replacing gem_package with rvm_gem)
#gem_package "bundler"
#gem_package "rake"
rvm_ruby node['graylog2']['ruby_version'] do
  # user node['graylog2']['web_user']
end

rvm_gemset node['graylog2']['ruby_string'] do
  action :create
end

rvm_gem "bundler" do
  ruby_string node['graylog2']['ruby_string']
  # user node['graylog2']['web_user']
end

rvm_gem "passenger" do
  ruby_string node['graylog2']['ruby_string']
    # user node['graylog2']['web_user']
  version node['graylog2']['passenger_version']
end

# Create the release directory
directory "#{node.graylog2.basedir}/rel" do
  mode 0755
  recursive true
end

# Download the desired version of Graylog2 web interface from GitHub
remote_file "download_web_interface" do
  path "#{node.graylog2.basedir}/rel/graylog2-web-interface-#{node.graylog2.web_interface.version}.tar.gz"
  source "https://github.com/downloads/Graylog2/graylog2-web-interface/graylog2-web-interface-#{node.graylog2.web_interface.version}.tar.gz"
  action :create_if_missing
end

# Unpack the desired version of Graylog2 web interface
execute "tar zxf graylog2-web-interface-#{node.graylog2.web_interface.version}.tar.gz" do
  cwd "#{node.graylog2.basedir}/rel"
   # creates checks whether the file exists, if yes, then the command is not run!
  creates "#{node.graylog2.basedir}/rel/graylog2-web-interface-#{node.graylog2.web_interface.version}/build_date"
  action :run
  subscribes :run, resources(:remote_file => "download_web_interface"), :immediately
end

# Link to the desired Graylog2 web interface version
link node['graylog2']['web_path'] do
  to "#{node.graylog2.basedir}/rel/graylog2-web-interface-#{node.graylog2.web_interface.version}"
end

# Perform bundle install on the newly-installed Graylog2 web interface version
#execute "rvm exec bundle install" do
rvm_shell 'bundle install' do
  ruby_string node['graylog2']['ruby_string']
  cwd node['graylog2']['web_path'] 
  # user node['graylog2']['web_user']
  action :run
  subscribes :run, resources(:link => node['graylog2']['web_path']), :immediately
end

# rvm_shell "passenger module install" do
#   user node['graylog2']['web_user']
#   group node['graylog2']['web_group']
#   creates "#{node['graylog2']['web_path']}/.rvm/gems/#{node['graylog2']['ruby_version']}/gems/passenger-#{node['graylog2']['passenger_version']}/ext/apache2/mod_passenger.so"
#   cwd node['graylog2']['web_path']
#   code %{passenger-install-apache2-module --auto}
# end

# rvm_shell "run bundler install" do
#   user node['graylog2']['web_user']
#   group node['graylog2']['web_group']
#   cwd node['graylog2']['web_path']
#   code %{bundle install}
# end


# Create mongoid.yml
template "#{node.graylog2.basedir}/web/config/mongoid.yml" do
  mode 0644
end

external_hostname = node.graylog2.external_hostname     ? node.graylog2.external_hostname :
    (node.has_key?('ec2') and node.ec2.has_key?('public_hostname')) ? node.ec2.public_hostname :
    (node.has_key?('ec2') and node.ec2.has_key?('public_ipv4'))     ? node.ec2.public_ipv4 :
    node.has_key?('fqdn')                                           ? node.fqdn :
    "localhost"

# Create general.yml
template "#{node.graylog2.basedir}/web/config/general.yml" do
  owner node['graylog2']['web_user']
  group node['graylog2']['web_group']
  mode 0644
  variables( :external_hostname => external_hostname )
end

execute "graylog2-web-interface owner-change" do
  command "chown -Rf #{node['graylog2']['web_user']}:#{node['graylog2']['web_group']} #{node['graylog2']['web_path']}"
end

# Stream message rake tasks
cron "Graylog2 send stream alarms" do
  user node['graylog2']['web_user']
  minute node.graylog2.stream_alarms_cron_minute
  action node.graylog2.send_stream_alarms ? :create : :delete
  command "cd #{node.graylog2.basedir}/web && source ~/.bashrc && RAILS_ENV=production bundle exec rake streamalarms:send"
end

cron "Graylog2 send stream subscriptions" do
  user node['graylog2']['web_user']
  minute node.graylog2.stream_subscriptions_cron_minute
  action node.graylog2.send_stream_subscriptions ? :create : :delete
  command "cd #{node.graylog2.basedir}/web && source ~/.bashrc && RAILS_ENV=production bundle exec rake subscriptions:send"
end
