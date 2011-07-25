#
# Cookbook Name:: solr
# Attributes:: solr
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:solr][:root] = "/opt/solr"

default[:solr][:version] = "3.3.0"
default[:solr][:archive_checksum] = "9a3e1d16ccccacd2b55bba73cd76803f6c37c1e8dc5b3b071dc33dc4e443d70b"

default[:solr][:clustering][:enabled] = true
