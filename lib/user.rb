class User
  include MongoMapper::Document

  # database 'mongo-rss'
  key :user_name, String
  key :real_name, String

  # stub method for unread items - replace with something real!
  attr_accessor :unread_items

end
