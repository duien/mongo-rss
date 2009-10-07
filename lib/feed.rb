require 'mongomapper'
require 'feedzirra'
require 'open-uri'

class Feed
  include MongoMapper::Document

  # database 'mongo-rss'

  # The feed's information about itself
  key :title,                  String
  key :feed_id,                String
  key :last_modified,          Time
  key :link,                   String # A link the the site
  key :etag,                   String
  
  # My information about the feed
  key :url,                    String # The URL of the feed
  key :last_successful_update, Time
  key :last_attempted_update,  Time

  # For Feedzirraing
  key :type,                   String

  many :items

  def update!
    with_updates = Feedzirra::Feed.update( feedzirra )
    if with_updates.updated?
      # update attributes
      title = with_updates.title
      link  = with_updates.url
    end
    if with_updates.has_new_entries?
      # do stuff with the new entries
      with_updates.new_entries.each do |entry|
        entry.sanitize!
        new_item = Item.new_from_feedzirra( entry )
        items << new_item
      end
    end

    # always update etag and modified
    etag          = with_updates.etag
    last_modified = with_updates.last_modified
    @feedzirra = with_updates
    save
  end

  def feedzirra
    if @feedzirra.nil?
      if type
        @feedzirra = eval(type).new
        @feedzirra.feed_url = url
        @feedzirra.last_modified = last_modified
        @feedzirra.etag = etag
        # @feedzirra.entries = items.sort_by{ |i| i.published_at }.last(1)
      else
        @feedzirra = Feedzirra::Feed.fetch_and_parse( url )
        do_first_update
      end
    end
    @feedzirra
  end

  def do_first_update
    self.title = @feedzirra.title
    self.link = @feedzirra.url
    self.type = @feedzirra.class
    self.etag = @feedzirra.etag
    self.last_modified = @feedzirra.last_modified
    @feedzirra.entries.each do |entry|
      entry.sanitize!
      new_item = Item.new_from_feedzirra( entry )
      items << new_item
    end
  end

end

