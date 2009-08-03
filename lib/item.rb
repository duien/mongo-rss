require 'mongomapper'

class Item
  include MongoMapper::Document

  # database 'mongo-rss'
  key :body, String
end
