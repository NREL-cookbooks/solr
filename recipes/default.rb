#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "rsync"
include_recipe "tomcat"

node.set[:solr][:contrib_dir] = "#{node[:solr][:root]}/contrib"
node.set[:solr][:dist_dir] = "#{node[:solr][:root]}/dist"
node.set[:solr][:webapp_dir] = "#{node[:solr][:root]}/webapp"

node.set[:solr][:instance][:home] = "#{node[:solr][:root]}/instance"
node.set[:solr][:instance][:conf_dir] = "#{node[:solr][:instance][:home]}/conf"
node.set[:solr][:instance][:data_dir] = "#{node[:solr][:instance][:home]}/data"
node.set[:solr][:instance][:lib_dir] = "#{node[:solr][:instance][:home]}/lib"

create_dirs = [
  node.set[:solr][:contrib_dir],
  node.set[:solr][:dist_dir],
  node.set[:solr][:webapp_dir],

  node.set[:solr][:instance][:home],
  node.set[:solr][:instance][:conf_dir],
  node.set[:solr][:instance][:data_dir],
  node.set[:solr][:instance][:lib_dir],
]

create_dirs.each do |path|
  directory path do
    owner node[:tomcat][:user]
    group node[:tomcat][:group]
    mode "0755"
    recursive true
  end
end

template "#{node[:tomcat][:context_dir]}/solr.xml" do
  source "tomcat_context.xml.erb"
  owner node[:tomcat][:user]
  group node[:tomcat][:group]
  mode "0644"
  notifies :restart, "service[tomcat6]"
end

version = node[:solr][:version]

remote_file "#{Chef::Config[:file_cache_path]}/apache-solr-#{version}.tgz" do
  source "http://apache.cs.utah.edu/lucene/solr/#{version}/apache-solr-#{version}.tgz"
  checksum node[:solr][:archive_checksum]
end

bash "install_solr" do
  cwd Chef::Config[:file_cache_path]
  code <<-EOH
    tar -xf apache-solr-#{version}.tgz

    rsync -a --delete-delay apache-solr-#{version}/dist/ #{node[:solr][:dist_dir]}
    rsync -a --delete-delay apache-solr-#{version}/contrib/ #{node[:solr][:contrib_dir]}
    cp apache-solr-#{version}/dist/apache-solr-#{version}.war #{node[:solr][:webapp_dir]}/

  EOH
    #rm -rf #{tmp}/apache-solr-#{version}

  not_if { ::File.exists?("#{node[:solr][:webapp_dir]}/apache-solr-#{version}.war") }
  notifies :restart, "service[tomcat6]"
end

template "#{node[:solr][:instance][:home]}/solr.xml" do
  source "solr.xml.erb"
  owner node[:tomcat][:user]
  group node[:tomcat][:group]
  mode "0644"
  notifies :restart, "service[tomcat6]"
end

%w{elevate.xml mapping-FoldToASCII.txt mapping-ISOLatin1Accent.txt protwords.txt schema.xml scripts.conf solrconfig.xml spellings.txt stopwords.txt synonyms.txt}.each do |file|
  template "#{node[:solr][:instance][:conf_dir]}/#{file}" do
    source "#{file}.erb"
    owner node[:tomcat][:user]
    group node[:tomcat][:group]
    mode "0644"
    notifies :restart, "service[tomcat6]"
  end
end
