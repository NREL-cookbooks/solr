#
# Cookbook Name:: solr
# Attributes:: solr
#
# Copyright 2011, NREL
#
# All rights reserved - Do Not Redistribute
#

default[:solr][:root] = "/opt/solr"

default[:solr][:version] = "3.6.0"
default[:solr][:archive_checksum] = "3acac4323ba3dbfa153d8ef01f156bab9b0eccf1b1f1f03e91b8b6739d3dc6c6"

default[:solr][:test_core][:enabled] = false

default[:solr][:clustering][:enabled] = true
