require 'sinatra'
require 'sinatra/reloader' if development?
require 'slim'
require 'sass'
require 'sinatra/flash'
require 'pony'
require 'v8'
require 'coffee-script'
require './thing'
require './sinatra/auth'

configure do
  set :session_secret, 'contransmagnificandjewbangtantiality'
  set :username, 'molly'
  set :password, 'bloom'
end

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
  set :email_address => 'smtp.gmail.com',
      :email_user_name => 'turingsam',
      :email_password => 'Turing1409',
      :email_domain => 'localhost.localdomain'
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
  set :email_address => 'smtp.sendgrid.net',
      :email_user_name => ENV['SENDGRID_USERNAME'],
      :email_password => ENV['SENDGRID_PASSWORD'],
      :email_domain => 'heroku.com'
end

helpers do
  def css(*stylesheets)
    stylesheets.map do |stylesheet|
      "<link href=\"/#{stylesheet}.css\" media=\"screen, projection\" rel=\"stylesheet\" />" 
    end.join
  end  

  def current?(path='/')
  	(request.path==path || request.path==path+'/') ? "current" : nil
  end

  def set_title
  	@title ||= "In Bloom's Pocket"
  end

  def send_message
    Pony.mail(
      :from        => params[:name] + "<" + params[:email] + ">", 
      :to          => 'turingsam@gmail.com',
      :subject     => params[:name] + " has contacted you", 
      :body        => params[:message] + " " + params[:email],
      :via         => :smtp,
      :via_options => {
        :address              => 'smtp.gmail.com', 
        :port                 => '587', 
        :enable_starttls_auto => true,
        :user_name            => 'turingsam',
        :password             => 'Turing1409',
        :authentication       => :plain,
        :domain               => 'localhost.localdomain'
      }) 
  end
end

before do 
	set_title
end	

get('/styles.css'){ scss :styles }
get('/javascripts/application.js'){ coffee :application }

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

get '/contact' do 
	slim :contact
end

post '/contact' do 
  send_message
  flash[:notice] = "Thanks for your message."
  redirect to('/')
end


