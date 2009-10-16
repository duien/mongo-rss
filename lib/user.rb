require 'mongo_mapper'

require_base = File.dirname( __FILE__ )
require File.join( require_base, 'hotness_signature' )
require File.join( require_base, 'subscription' )

class User
  include MongoMapper::Document

  # database 'mongo-rss'
  key :user_name, String, :required => true
  key :real_name, String, :required => true
  key :hotness_signature, HotnessSignature

  many :subscriptions

  def initialize( attrs = {} )
    super attrs
    self.hotness_signature ||= HotnessSignature.new
  end
  
  # STUB - fix the tests once removed
  attr_accessor :items

  SORTING_STRATEGIES = {
    :hottest   => lambda { |i, u| u.hotness_signature.predict( i.body ) * -1 },
    :newest    => lambda { |i, u| i.published_at.to_i * -1 },
    :oldest    => lambda { |i, u| i.published_at },
    :unordered => lambda { |i, u| 0 }
  }

  def feeds
    subscriptions.collect { |s| s.feed }
  end

  def items
    feeds.inject([]) { | items, feed | items + feed.items }
  end

  def subscribe (feed)
    return if feeds.include? feed
    s = Subscription.new(:feed => feed)
    subscriptions << s
  end

  # All the unread items from all of this user's feeds.  The options hash can
  # take the following keys:
  #
  #     :order => one of :newest, :oldest, :hottest, or :unordered
  #
  def unread_items (options = {})
    order = options[:order] || :hottest
    raise "Invalid ordering '#{order.to_s}' on unread items" if !SORTING_STRATEGIES.key?(order)
    items.sort_by { |i| SORTING_STRATEGIES[order].call(i, self) }
  end

  # Mark an item as read, and as having taken a certain amount of time to read.
  #
  def read ( item, time )
    # TODO: come up with a better determination of item weight
    weight = time

    hotness_signature.train( item.body, weight )
  end
  
end
