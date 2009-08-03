require 'mongomapper'

class User
  include MongoMapper::Document

  # database 'mongo-rss'
  key :user_name, String
  key :real_name, String
  key :feeds, Array, :default => []
end
