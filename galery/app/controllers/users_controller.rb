require 'sinatra/base'
require 'rack-flash'

class UsersController < ApplicationController
  use Rack::Flash

        get '/user/:slug' do
          @user = User.find_by_slug(params[:slug])
          erb :'home'
        end

        get '/signup' do
          if Helpers.is_logged_in? session
            redirect '/home'
          else
            erb :'users/register'
          end
        end

      post '/signup' do
        user = User.find_by(email: params[:email]) unless params[:email].empty?
        if user
          flash[:error] = 'this email exist already. <br> go to the login page to sign in'
          redirect '/signup'
        else
          user = User.new params

          if user.save
            session[:user_id] = user.id
            redirect '/'
          else
            redirect '/signup'
          end
        end
      end

      get '/new-picture' do 
        if Helpers.is_logged_in? session
          @user = Helpers.current_user session
          erb :'pictures/new'
        else
          redirect '/'
        end
      end


      post '/new-picture' do 
        @filename = params[:file][:filename]
          file = params[:file][:tempfile]
          if @filename
          File.open("./public/#{@filename}", 'wb') do |f|
            f.write(file.read)
            Galery.create(name: @filename, user_id: params[:user_id], description: params[:description])
            redirect '/home'
          end  
        else
          redirect to '/login'
        end
      end



      get '/edit/galery/:id' do
        if Helpers.is_logged_in? session
          @galery = Galery.find(params[:id])
          erb:"pictures/edit"
        else
          redirect to '/login'
        end
      end


      post '/edit/galery/:id' do
        if Helpers.is_logged_in? session
          @galery = Galery.find(params[:id])
          @galery.update(params)
          redirect '/home'
        else
          redirect to '/login'
        end
      end



      delete '/users/delete/:id' do
        if Helpers.is_logged_in? session
          @galery = Galery.find_by_id(params[:id])
          @galery.delete
          if @galery.delete
            redirect to '/home'
          end
        else
          redirect to '/login'
        end
      end


      get '/users' do
        if Helpers.is_logged_in? session
          @user = Helpers.current_user session
          @users = User.all
          erb :'/users/index'
        else
          redirect '/'
        end
      
      end

      get '/friend-request/:id' do 
        
        if Helpers.is_logged_in? session
          @user = Helpers.current_user session
          @user.friends.create(friend_id: params[:id])
          redirect back
        else
          redirect '/'
        end
      end

      get '/friend-request/update/:id' do 
        if Helpers.is_logged_in? session
            @user = Helpers.current_user session

            user = User.find(params[:id])

            @friend = user.friend_check(@user.id)

            if @friend.confirm?
              @friend.update(confirm: false)
              redirect back
            else
              @friend.update(confirm: true)
              redirect back
            end
          else
            redirect '/'
        end
      end

end