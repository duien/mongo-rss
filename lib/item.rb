require 'mongomapper'

class Item
  include MongoMapper::Document

  # database 'mongo-rss'
  key :guid, String  # This refers to the id provided by the feed, not the database id
  key :link, String
  key :title, String
  key :body, String
  key :published_at, Time
end
