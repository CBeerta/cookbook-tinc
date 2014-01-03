#
# Cookbook Name:: tinc
# Recipe:: default
#
# Copyright 2011, Claus Beerta
#
# Permission is hereby granted, free of charge, to any person obtaining
# a copy of this software and associated documentation files (the
# "Software"), to deal in the Software without restriction, including
# without limitation the rights to use, copy, modify, merge, publish,
# distribute, sublicense, and/or sell copies of the Software, and to
# permit persons to whom the Software is furnished to do so, subject to
# the following conditions:
#
# The above copyright notice and this permission notice shall be
# included in all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
# EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
# MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
# NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
# LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
# OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
# WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#

package "tinc"

case node['platform']
when "centos", "redhat", "amazon", "scientific"
      template "tinc" do
      path "/etc/init.d/tinc"
      source "tinc.init.erb"
      owner "root"
      group "root"
      mode 0755
      notifies :start, "service[tinc]", :delayed
    end
end

service "tinc" do
  supports value_for_platform(
    "debian" => { "default" => [ :restart, :reload ] },
    "ubuntu" => { "default" => [ :restart, :reload ] },
    "centos" => { "default" => [ :restart, :reload, :status ] },
    "redhat" => { "default" => [ :restart, :reload, :status ] },
    "fedora" => { "default" => [ :restart, :reload, :status ] },
    "arch" => { "default" => [ :restart ] },
    "default" => { "default" => [:restart, :reload ] }
  )

  action :enable
end

remote_directory "tinc-copy-host-keys" do
  path "/etc/tinc/#{node['tinc']['net_name']}/hosts"
  source "hosts"
  files_backup 5
  files_owner "root"
  files_group "root"
  files_mode 00600
  owner "root"
  group "root"
  mode 00600
  purge false
  overwrite true
  notifies :start, "service[tinc]", :delayed
end

template "tinc.conf" do
  path "/etc/tinc/#{node['tinc']['net_name']}/tinc.conf"
  source "tinc.conf.erb"
  owner "root"
  group "root"
  mode 0644
  notifies :start, "service[tinc]", :delayed
end

template "tinc-up" do
  path "/etc/tinc/#{node['tinc']['net_name']}/tinc-up"
  source "tinc-up.erb"
  owner "root"
  group "root"
  mode 0755
end

template "nets.boot" do
  path "/etc/tinc/nets.boot"
  source "nets.boot.erb"
  owner "root"
  group "root"
  mode 0644
end

