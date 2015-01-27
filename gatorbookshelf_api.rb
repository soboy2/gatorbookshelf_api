#%w[rubygems sinatra data_mapper].each{ |r| require r }
require 'sinatra'
require 'json'
require 'data_mapper'
# require 'dm-postgres-adapter'
# require 'dm-sqlite-adapter'
require 'bcrypt'

DataMapper::Logger.new($stdout, :debug)
#DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

configure :development do
  DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/development.db")
end

configure :production do
  DataMapper.setup(:default, ENV['DATABASE_URL'])
end

class User
  include DataMapper::Resource
  property :id,           Serial, :key => true
  property :username,     String, :required => true
  property :password,     BCryptHash, :required => true
  property :email,        String, :format => :email_address, :required => true
  property :token,        Text
  property :role,         String
  property :member_since, DateTime
  property :updated_at,   DateTime

  has n, :listing

  def generate_token!
    self.token = SecureRandom.urlsafe_base64(64)
    self.save!
  end

end

class Listing
  include DataMapper::Resource
  property :id,             Serial, :key => true
  property :user_id,        String, :required => true
  property :author,         String
  property :title,          Text
  property :description,    Text
  property :price,          String
  property :status,         String
  property :created_at,     DateTime
  property :updated_at,     DateTime

  belongs_to :user
end

DataMapper.finalize

def authenticate!
  @user = User.first(:token => @access_token)
  halt 403 unless @user
end

before do
  begin
    if request.env["HTTP_ACCESS_TOKEN"].is_a?(String)
      @access_token = request.env["HTTP_ACCESS_TOKEN"]
    end

    if request.body.read(1)
      request.body.rewind
      @request_payload = JSON.parse request.body.read, { symbolize_names: true}

    end

  rescue JSON::ParserError => e
    request.body.rewind
    puts "The body #{request.body.read} was not JSON"
  end
end

get '/heartbeat' do
  response = {status: 'alive'}
  status 200
  content_type :json
  body response.to_json
end

#user register
post '/user' do
  response = ''
  user_check = User.first(:username => @request_payload[:username])
  puts "**** Check if user #{@request_payload[:username]} exists"
  if user_check.nil? then
    user = User.first_or_create(
            :username => @request_payload[:username],
            :email => @request_payload[:email],
            :password => @request_payload[:password],
            :role => 'member',
            :member_since => Time.now,
            :updated_at => Time.now
          )


    if user.save
      puts "***** added a new user @ " + user.id.to_s
      response = {status: 'success', id: user.id}
      status 201
    else
      status 500
      puts 'failed'
      response = {status: 'error'}
    end
  else
    status 404
    puts 'user already exists'
    response = {error: 'select another username'}
  end
  # #@user.raise_on_save_failure = true
  # #@user.first_or_create
  content_type :json
  puts response
  body response.to_json
end

#user login
post '/login' do
  puts "****** User " + @request_payload[:username] + " attempting to login"
  user = User.first(:username => @request_payload[:username])
  if user.password == @request_payload[:password]
    if(user.token == nil)
      user.generate_token!
    end
    response = {access_token: user.token, id: user.id, username: user.username, email: user.email}
    status 200
  else
    reponse = {error: 'Username or Password is Invalid'}
    status 401
  end

  content_type :json
  body response.to_json
end

#add new listing
post '/listing' do
  listing = params[:listing]
  listing[:owner_id] = 'bob'


  content_type :json


  # @author = params[:author]
  # @title = params[:title]
  # @description = params[:description]
  # @listing_price = params[:listing_price]
  # @owner_id = params[:owner_id] #need to get this from session?

  response = {status: 'success', listing: listing}

  status 200
  body response.to_json
end

#search for a listing that matches the keyword
get '/search/:keyword' do
  content_type :json
  keyword = params[:keyword]
  results = ''
  if(keyword == 'lord of the rings')
    results = [
      {
        author: "R Tolkein",
        title: "Lord of the rings: The hobbit",
        last_update: "2015-01-05T11:30:00Z",
        description: "Looks great",
        listing_id: 1,
        user_id: 2,
        listing_price: 33
      },
      {
        author: "R Tolkein",
        title: "Lord of the rings: Fellowship of the Ring",
        last_update: "2015-02-06T10:30:00Z",
        description: "Looks great",
        listing_id: 2,
        user_id: 3,
        listing_price: 30
      }
    ]

  else
    results = {error: 'no matches found'}
  end
  results.to_json
end
