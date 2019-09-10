require './config/environment'
require 'sinatra/base'
require 'rack-flash'
require 'sinatra/redirect_with_flash'

class ApplicationController < Sinatra::Base
  use Rack::Flash
  set :method_override, true

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, ""
  end

  get "/" do
    if Helpers.is_logged_in? session
      redirect '/home'
    else
      erb :index
    end
  end

  get "/home" do
    if Helpers.is_logged_in? session
      @user = Helpers.current_user session
      erb :home
    else
      erb :index
    end
  end

  get "/home/:id" do
    if Helpers.is_logged_in? session
      @user = User.find(params[:id])
      erb :home
    else
      erb :index
    end
  end

  get '/login' do
    if Helpers.is_logged_in? session
      redirect '/home'
    else
      redirect '/'
    end
  end

  post '/login' do
    user = User.find_by(email: params[:email]) unless params[:email].empty?
    if !user
      flash[:error] = 'This email doesn\'t exist. <br> If you don\'t have an accout, create one!'
      redirect '/'
    end
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect '/home'
    else
      flash[:error] = 'invalid email or password. <br> If you don\'t have an accout, create one!'
      redirect '/'
      #redirect '/signup'
    end
  end

  get '/logout' do
    if Helpers.is_logged_in? session
      session.clear
      redirect to '/'
    else
      redirect to '/'
    end
  end


end