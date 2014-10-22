require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'
require './thing'

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







