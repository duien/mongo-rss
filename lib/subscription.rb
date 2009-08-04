require 'mongomapper'

class Subscription
  include MongoMapper::EmbeddedDocument

  belongs_to :feed

end
