#
# Cookbook Name:: solr
# Attributes:: solr
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:solr][:root] = "/opt/solr"

default[:solr][:version] = "3.5.0"
default[:solr][:archive_checksum] = "804f3ba9d1296f81388605a79538b7362355693fbdd03b7b2dbf9a706bf1d1d0"

default[:solr][:test_core][:enabled] = false

default[:solr][:clustering][:enabled] = true
