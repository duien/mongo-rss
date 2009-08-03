require 'mongomapper'

class Feed
  include MongoMapper::Document

  # database 'mongo-rss'
  key :title, String
  key :url, String
  key :last_updated, Time
end

