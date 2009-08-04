require 'mongomapper'

class User
  include MongoMapper::Document

  # database 'mongo-rss'
  key :user_name, String
  key :real_name, String
  key :feeds, Array, :default => []

  # STUB - fix the tests once removed
  attr_accessor :items

  SORTING_STRATEGIES = {
    :hottest => lambda { |a, b| 0 },
    :newest => lambda { |a, b| b.published_at <=> a.published_at },
    :oldest => lambda { |a, b| a.published_at <=> b.published_at },
    :unordered => lambda { |a, b| 0 }
  }

  # All the unread items from all of this user's feeds.  The options hash can
  # take the following keys:
  #
  #     :order => one of :newest, :oldest, :hottest, or :unordered
  #
  def unread_items (options = {})
    order = options[:order] || :hottest
    raise "Invalid ordering '#{order.to_s}' on unread items" if !SORTING_STRATEGIES.key?(order)
    @items.sort { |a, b| SORTING_STRATEGIES[order].call(a, b) }
  end

  # Mark an item as read, and as having taken a certain amount of time to read.
  #
  def read ( item, time )
  end
end
