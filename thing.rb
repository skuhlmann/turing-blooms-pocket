require 'dm-core'
require 'dm-migrations'

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

module ThingHelpers
	def find_things
		@things = Thing.all
	end

	def find_thing
		Thing.get(params[:id])
	end

	def create_thing
		@thing = Thing.create(params[:thing])
	end
end

helpers ThingHelpers

get '/things' do 
	find_things
	slim :things
end

get '/things/new' do 
	protected!
	@thing = Thing.new
	slim :new_thing
end

get '/things/:id' do 
	@thing = find_thing
	slim :show_thing
end

get '/things/:id/edit' do
	protected!
	@thing = find_thing
	slim :edit_thing
end

post '/things' do 
	flash[:notice] = "This thing is now in Bloom's pocket" if create_thing
	redirect to("/things/#{@thing.id}")
end

put '/things/:id' do
  thing = find_thing
  if thing.update(params[:thing])
  	flash[:notice] = "This thing has been updated"
  end
  redirect to("/things/#{thing.id}")
end

delete '/things/:id' do
	protected!
  if find_thing.destroy
  	flash[:notice] = "A thing has been taken out of Bloom's pocket"
  end
  redirect to('/things')
end


