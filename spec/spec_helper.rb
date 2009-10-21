require 'mongo_mapper'

# load all the models
Dir.foreach( File.join(File.dirname(__FILE__), '..', 'lib') ) do |file| 
  require file if file =~ /\.rb$/
end

MongoMapper.database = 'mongo-test'
