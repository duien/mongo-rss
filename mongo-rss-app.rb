require 'rubygems'
require 'sinatra/base'
require 'mongomapper'

require_base = File.join( File.dirname( __FILE__ ), 'lib' )
require File.join( require_base, 'user' )
require File.join( require_base, 'feed' )
require File.join( require_base, 'item' )

class MongoRSS < Sinatra::Base
  
  configure do
    MongoMapper.database = 'mongo-rss'
  end

  enable :sessions
  set :root, File.dirname( __FILE__ )

  # Manage your sessions here, folks!
  get '/login/?' do
    haml :login
  end

  get '/logout/?' do
    session.clear
    haml :logout
  end

  post '/login/?' do
    session['user'] = params['user']
    redirect '/'
  end

  # Actual stuff (maybe) 

  get '/' do
    haml :index
  end

end
