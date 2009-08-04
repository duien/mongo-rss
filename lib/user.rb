require 'mongomapper'

class User
  include MongoMapper::Document

  # database 'mongo-rss'
  key :user_name, String
  key :real_name, String
  key :feeds, Array, :default => []

  # STUB - fix the tests once removed
  attr_accessor :items

  # All the unread items from all of this user's feeds.  The options hash can
  # take the following keys:
  #
  #     :order => one of :newest, :oldest, :hottest, or :unordered
  #
  def unread_items (options = {})
    @items    # TODO: implement this
  end
end
