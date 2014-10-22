require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'
require './thing'

configure do
  enable :sessions
  set :session_secret, 'contransmagnificandjewbangtantiality'
  set :username, 'molly'
  set :password, 'bloom'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

get('/styles.css'){ scss :styles }

get '/' do
  slim :home
end

get '/about' do 
	@title = "About This Website"
	slim :about 
end

get '/contact' do 
	@title = "Don't Contact Me"
	slim :contact
end

not_found do
  slim :not_found
end

get '/login' do 
	slim :login
end

post '/login' do 
	if params[:username] == settings.username && params[:password] == settings.password
		session[:admin] = true
		redirect to('/things')
	else
		slim :login
	end
end

get '/logout' do
  session.clear
  redirect to('/login')
end









