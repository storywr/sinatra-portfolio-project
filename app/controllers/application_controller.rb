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

  get '/homepage' do
    erb :homepage
  end

  get '/signup' do
    if logged_in?
      redirect "/teams"
    else
      erb :'users/create_user'
    end
  end

  post '/signup' do
    user = User.new(username: params[:username], email: params[:email], password: params[:password])
    if user.save
      session[:user_id] = user.id
      redirect "/homepage"
    else
      erb :'users/signup_failure'
    end
  end

  get '/login' do
    if logged_in?
      erb :homepage
    else
      erb :'users/login'
    end
  end

  post '/login' do
    user = User.find_by(username: params[:username])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect "/homepage"
    else
      erb :'users/login_failure'
    end
  end

  get '/users' do
    @users = User.all
    erb :'users/user_index'
  end

  get '/teams' do
    @teams = Team.all
    if logged_in?
      erb :'teams/teams'
    else
      redirect "/login"
    end
  end

  get '/teams/new' do
    if logged_in?
      erb :'teams/create_team'
    else
      redirect "/login"
    end
  end

  post '/teams' do
    @team = Team.new(name: params[:name], qb: params[:qb], rb: params[:rb], wr: params[:wr], te: params[:te], defense: params[:defense], kicker: params[:kicker], user_id: current_user.id)
    @team.user = current_user
    @team.save
    redirect "/teams"
  end

  get '/teams/:id' do
    if logged_in?
      @team = Team.find_by(id: params[:id])
      erb :'teams/show_team'
    else
      redirect "/login"
    end
  end

  get '/teams/:id/edit' do
    if logged_in?
      @team = Team.find_by(id: params[:id])
      erb :'teams/edit_team'
    else
      redirect "/login"
    end
  end

  patch '/teams/:id' do
    @team = Team.find_by(id: params[:id])
    if current_user == @team.user
      @team.name = params[:name]
      @team.qb = params[:qb]
      @team.rb = params[:rb]
      @team.wr = params[:wr]
      @team.te = params[:te]
      @team.defense = params[:defense]
      @team.kicker = params[:kicker]
      @team.save
      redirect to "/teams/#{@team.id}"
    else
      erb :not_your_team
    end
  end

  delete '/teams/:id/delete' do
    @team = Team.find_by(id: params[:id])
    if current_user == @team.user
      @team.delete
      redirect to '/teams'
    else
      erb :not_your_team
    end
  end

  post '/teams/:id' do
    @team = Team.find_by(params[:username])
    @team.save
    redirect to "teams/#{@team.id}"
  end

  get '/users/:slug' do
    @user = User.find_by_slug(params[:slug])
    erb :'teams/single_user_teams'
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
