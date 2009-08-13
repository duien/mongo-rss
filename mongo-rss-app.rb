require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'sass'

require_base = File.join( File.dirname( __FILE__ ), 'lib' )
require File.join( require_base, 'user' )
require File.join( require_base, 'feed' )
require File.join( require_base, 'item' )
require File.join( require_base, 'subscription' )

class MongoRSS < Sinatra::Base
  
  configure do
    MongoMapper.database = 'mongo-rss'
  end

  enable :sessions, :static
  set :root, File.dirname( __FILE__ )

  # Manage your sessions here, folks!

  get '/login/?' do
    custom_haml :login
  end

  get '/logout/?' do
    session.clear
    flash[:notice] = 'Logged out'
    redirect '/'
  end

  post '/login/?' do
    user = User.all( :conditions => {:user_name => params[:user_name]} )
    if( user.empty? )
      flash[:error] = 'Unable to find account. Please sign up for a new account'
      redirect '/signup'
    else
      session[:user] = user.first
      flash[:notice] = 'Logged in'
      redirect session[:login_should_redirect] ? session.delete(:login_should_redirect) : '/'
    end
  end

  get '/signup/?' do
    custom_haml :signup
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
    if logged_in?
      custom_haml :index
    else
      custom_haml :welcome
    end
  end

  get '/subscriptions/?' do
    login_required!
    @subscriptions = session[:user].subscriptions
    # @feeds = []
    custom_haml :subscriptions
  end

  get '/feeds/?' do
    login_required!
    @feeds = Feed.find( :all )
    custom_haml :feeds
  end

  get '/feeds/:id/items/?' do
    login_required!
    @feed = Feed.find( params[:id] )
    custom_haml :feed_items
  end

  # Other
  
  get '/:style.css' do
    begin
      content_type 'text/css'
      sass params[:style].to_sym
    rescue Errno::ENOENT
      pass
    end
  end

  # Filters

  # before do
  #   puts "in the before filter"
  #   path_regex = %r{^/(signup|login|.*\.css|$)}
  #   puts "[logged_in?]#{logged_in?} [path match]#{request.path_info =~ path_regex}"
  #   unless logged_in? or request.path_info =~ path_regex
  #     flash[:error] = 'You must be logged in'
  #     session[:login_should_redirect] = request.path_info
  #     request.path_info = '/login'
  #   end
  # end

  # Helpers
  
  def flash
    session[:flash] = {} if session[:flash] && session[:flash].class != Hash
    session[:flash] ||= {}
  end
  
  def custom_haml(*args)
    render_result = haml(*args)
    flash.clear
    render_result
  end

  def nav_link( target, title )
    # haml_concat "%a{ :href => '#{target}', :class => request.path_info == '#{target}' ? 'current' : nil } #{title}"
    haml_tag :li, :< do
      haml_tag :a, title, :<,  { :href => target, :class => request.path_info == target ? 'current' : nil }
    end
  end

  def logged_in?
    not session[:user].nil?
  end
  
  def login_required!
    unless logged_in?
      flash[:error] = 'You must be logged in'
      session[:login_should_redirect] = request.path
      redirect '/login'
    end
  end

end
