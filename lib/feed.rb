require 'mongomapper'
require 'feed-normalizer'
require 'open-uri'

class Feed
  include MongoMapper::Document

  # database 'mongo-rss'
  key :title, String
  key :description, String
  key :feed_id, String
  key :last_updated, Time
  key :copyright, String
  key :authors, Array
  key :site_urls, Array
  key :generator, String
  key :ttl, String
  key :skip_hours, String
  key :skip_days, String

  key :url, String
  key :last_successful_update, Time
  key :last_attempted_update, Time

  def update!
    update_time = Time.now
    last_attempted_update = update_time
    begin
      feed = FeedNormalizer::FeedNormalizer.parse open( url )
      feed.clean!

      # do we actually need to do anything?
      return if feed.last_updated and last_successful_update and feed.last_updated < last_successful_update

      # update any attributes on the feed
      FeedNormalizer::Feed::ELEMENTS.each do |element|
        key = case element
              when :urls
                :site_urls
              when :id
                :feed_id
              when :items, :image
                next
              else
                element
              end
        self[key] = feed.send( element ) unless feed.send( element ).nil?
      end
      last_successful_update = update_time
    rescue
      raise
    ensure
      save
    end
  end
end

