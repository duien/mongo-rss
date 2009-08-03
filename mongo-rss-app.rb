require 'rubygems'
require 'sinatra/base'
require 'mongomapper'
require 'haml'

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
    flash[:notice] = 'Logged out'
    haml :logout
  end

  post '/login/?' do
    user = User.all( :conditions => {:user_name => params[:user_name]} )
    if( user.empty? )
      flash[:error] = 'Unable to find account. Please sign up for a new account'
      redirect '/signup'
    else
      session['user'] = user.first
      flash[:notice] = 'Logged in'
      redirect '/'
    end
  end

  get '/signup/?' do
    haml :signup
  end

  post '/signup/?' do
    if User.create( params[:user] )
      flash[:notice] = 'Account created. Please sign in'
      redirect '/login'
    else
      flash[:error] = 'Unable to create account'
      redirect '/signup'
    end
  end

  # Actual stuff

   get '/' do
    redirect '/welcome' unless session['user']
    haml :index
  end

  get '/welcome/?' do
    haml :welcome
  end

  # Other
  
  get '/:style.css' do
    content_type 'text/css'
    sass params[:style].to_sym
  end

  # Helpers
  
  def flash
    session[:flash] = {} if session[:flash] && session[:flash].class != Hash
    session[:flash] ||= {}
  end
  
  alias :original_haml :haml

  def haml(*args)
    render_result = original_haml(*args)
    flash.clear
    render_result
  end

end
