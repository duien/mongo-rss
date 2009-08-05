require 'mongomapper'

class HotnessSignature
  include MongoMapper::Document

  belongs_to :user
  key :serialized_classifier, String

  def after_create
    @classifier = Classifier::Bayes.new( :categories => [ :hot ] )
  end

  def before_save
    serialized_classifier = Marshal.dump( @classifier )
  end

  def classifier
    @classifier || serialized_classifier.nil? ? nil : Marshal.restore( serialized_classifier )
  end

end
