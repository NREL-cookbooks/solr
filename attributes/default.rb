#
# Cookbook Name:: solr
# Attributes:: solr
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:solr][:root] = "/opt/solr"

default[:solr][:version] = "3.6.2"
default[:solr][:archive_checksum] = "537426dcbdd0dc82dd5bf16b48b6bcaf87cb4049c1245eea8dcb79eeaf3e7ac6"

default[:solr][:test_core][:enabled] = false

default[:solr][:clustering][:enabled] = true
