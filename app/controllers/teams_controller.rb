class TeamsController < ApplicationController

  get '/teams' do
    @teams = Team.all
    if logged_in?
      erb :'teams/teams'
    else
      redirect "/session/login"
    end
  end

  get '/teams/new' do
    if logged_in?
      erb :'teams/create_team'
    else
      redirect "/session/login"
    end
  end

  post '/teams' do
    @team = Team.new(params)
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
      @team.update(params[:team])
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

end
