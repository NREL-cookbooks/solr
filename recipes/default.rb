#
# Cookbook Name:: solr
# Recipe:: default
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

include_recipe "tomcat"

cookbook_file "#{node[:tomcat][:webapp_dir]}/solr.war" do
  source "apache-solr-3.2.0.war"
  owner node[:tomcat][:user]
  group node[:tomcat][:group]
  mode "0644"
  notifies :restart, "service[tomcat6]"
end

node.set[:solr][:conf_dir] = "#{node[:solr][:home]}/conf"
node.set[:solr][:data_dir] = "#{node[:solr][:home]}/data"

[node[:solr][:home], node[:solr][:conf_dir], node[:solr][:data_dir]].each do |path|
  directory path do
    owner node[:tomcat][:user]
    group node[:tomcat][:group]
    mode "0755"
    recursive true
  end
end

template "#{node[:solr][:home]}/solr.xml" do
  source "solr.xml.erb"
  owner node[:tomcat][:user]
  group node[:tomcat][:group]
  mode "0644"
  notifies :restart, "service[tomcat6]"
end

%w{elevate.xml mapping-FoldToASCII.txt mapping-ISOLatin1Accent.txt protwords.txt schema.xml scripts.conf solrconfig.xml spellings.txt stopwords.txt synonyms.txt}.each do |file|
  template "#{node[:solr][:conf_dir]}/#{file}" do
    source "#{file}.erb"
    owner node[:tomcat][:user]
    group node[:tomcat][:group]
    mode "0644"
    notifies :restart, "service[tomcat6]"
  end
end
