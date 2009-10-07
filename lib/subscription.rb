require 'mongomapper'

class Subscription
  include MongoMapper::EmbeddedDocument

  belongs_to :feed
  key :feed_id, String

end
