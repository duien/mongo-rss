require 'mongo_mapper'

class Item
  include MongoMapper::EmbeddedDocument

  # database 'mongo-rss'
  key :guid, String  # This refers to the id provided by the feed, not the database id
  key :link, String
  key :title, String
  key :author, String
  key :content, String
  key :summary, String
  key :categories, Array
  key :links, Array
  key :updated_at, Time
  key :published_at, Time
  
  def self.new_from_feedzirra( entry )
    new(
      :guid => entry.id,
      :link => entry.url,
      :title => entry.title,
      :author => entry.author,
      :content => entry.content,
      :summary => entry.summary,
      :categories => entry.categories,
      :links => (entry.respond_to?(:links) ? entry.links : [] ),
      :updated_at => entry.updated,
      :published_at => entry.published
    )
  end

  def body
    # content or summary as appropriate
    content || summary
  end

  def inspect
    "'#{body}'"
  end
end
