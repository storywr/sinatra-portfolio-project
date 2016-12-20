class SessionController < ApplicationController

  get '/session/login' do
    if logged_in?
      erb :index
    else
      erb :'session/login'
    end
  end

  post '/session' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/"
    else
      erb :'users/login_failure'
    end
  end

  delete '/session' do
    session.clear
    redirect "/session/login"
  end

end
