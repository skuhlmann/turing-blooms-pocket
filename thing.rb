require 'dm-core'
require 'dm-migrations'

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")

class Thing
	include DataMapper::Resource
	property :id,          Serial
	property :title,       String
	property :section,     String
	property :lines,       Text
	property :line_number, Integer
	property :time_of_day, Date

	def time_of_day=date
		super Date.strptime(date, '%m/%d/%Y')
	end
end

DataMapper.finalize

get '/things' do 
	@things = Thing.all
	slim :things
end

get '/things/new' do 
	@thing = Thing.new
	slim :new_thing
end

get '/things/:id' do 
	@thing = Thing.get(params[:id])
	slim :show_thing
end

get '/things/:id/edit' do 
	@thing = Thing.get(params[:id])
	slim :edit_thing
end

post '/things' do 
	thing = Thing.create(params[:thing])
	redirect to("/things/#{thing.id}")
end

put '/things/:id' do
  thing = Thing.get(params[:id])
  thing.update(params[:thing])
  redirect to("/things/#{thing.id}")
end

delete '/things/:id' do
  Thing.get(params[:id]).destroy
  redirect to('/things')
end


