require 'mongomapper'

require_base = File.dirname( __FILE__ )
require File.join( require_base, 'hotness_signature' )

class User
  include MongoMapper::Document

  # database 'mongo-rss'
  key :user_name, String
  key :real_name, String
  key :hotness_signature, HotnessSignature

  many :subscriptions

  # STUB - fix the tests once removed
  attr_accessor :items

  SORTING_STRATEGIES = {
    :hottest   => lambda { |i, u| u.hotness_signature.predict( i.body ) * -1 },
    :newest    => lambda { |i, u| i.published_at.to_i * -1 },
    :oldest    => lambda { |i, u| i.published_at },
    :unordered => lambda { |i, u| 0 }
  }

  # All the unread items from all of this user's feeds.  The options hash can
  # take the following keys:
  #
  #     :order => one of :newest, :oldest, :hottest, or :unordered
  #
  def unread_items (options = {})
    @hotness_signature ||= HotnessSignature.new # HACK! No after_initialize callback?

    order = options[:order] || :hottest
    raise "Invalid ordering '#{order.to_s}' on unread items" if !SORTING_STRATEGIES.key?(order)
    @items.sort_by { |i| SORTING_STRATEGIES[order].call(i, self) }
  end

  # Mark an item as read, and as having taken a certain amount of time to read.
  #
  def read ( item, time )
    # TODO: come up with a better determination of item weight
    weight = time

    @hotness_signature ||= HotnessSignature.new # HACK! No after_initialize callback?
    @hotness_signature.train( item.body, weight )
  end
  
end
