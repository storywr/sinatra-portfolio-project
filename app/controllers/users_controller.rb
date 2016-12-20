class UsersController < ApplicationController

  get '/users/signup' do
    if logged_in?
      redirect "/teams"
    else
      erb :'users/create_user'
    end
  end

  post '/users' do
    user = User.new(params)
    if user.save
      session[:user_id] = user.id
      redirect "/"
    else
      erb :'users/signup_failure'
    end
  end

  get '/users' do
    @users = User.all
    erb :'users/user_index'
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'teams/single_user_teams'
  end

end
