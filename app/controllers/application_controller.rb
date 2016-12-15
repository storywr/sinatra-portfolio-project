require './config/environment'

class ApplicationController < Sinatra::Base

  configure do
    set :public_folder, 'public'
    set :views, 'app/views'
    enable :sessions
    set :session_secret, "secret"
  end

  get '/' do
    erb :index
  end

  get '/signup' do
    if logged_in?
      redirect "/tweets"
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    user = User.new(username: params[:username], email: params[:email], password: params[:password])
    if user.save
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/signup_failure"
    end
  end

  get '/login' do
    if logged_in?
      redirect "/tweets"
    else
      erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/tweets"
    else
      redirect "/login_failure"
    end
  end

  get '/tweets' do
    @tweets = Tweet.all
    if logged_in?
      erb :'tweets/tweets'
    else
      redirect "/login"
    end
  end

  get '/tweets/new' do
    if logged_in?
      erb :'tweets/create_tweet'
    else
      redirect "/login"
    end
  end

  post '/tweets' do
    if params[:content] != ""
      @tweet = Tweet.new(content: params[:content], user_id: current_user.id)
      @tweet.save
    else
      redirect "/tweets/new"
    end
  end

  get '/tweets/:id' do
    if logged_in?
      @tweet = Tweet.find_by(params[:id])
      erb :'tweets/show_tweet'
    else
      redirect "/login"
    end
  end

  get '/tweets/:id/edit' do
    if logged_in?
      @tweet = Tweet.find_by(params[:id])
      erb :'tweets/edit_tweet'
    else
      redirect "/login"
    end
  end

  patch '/tweets/:id' do
    @tweet = Tweet.find_by(params[:id])
    if params[:content] != ""
      @tweet.content = params[:content]
      @tweet.save
      redirect to "/tweets/#{@tweet.id}"
    else
      redirect to "/tweets/#{@tweet.id}/edit"
    end
  end

  delete '/tweets/:id/delete' do
    @tweet = Tweet.find_by(params[:id])
    @tweet.delete
    redirect to '/tweets'
  end

  post '/tweets/:id' do
    @tweet = Tweet.find_by(params[:username])
    @tweet.save
    redirect to "tweets/#{@tweet.id}"
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'tweets/single_user_tweets'
  end

  get "/logout" do
    if logged_in?
      session.clear
      redirect "/login"
    else
      redirect "/login"
    end
  end

  helpers do
    def logged_in?
      !!session[:user_id]
    end

    def current_user
      User.find(session[:user_id])
    end
  end

end
