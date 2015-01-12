require 'sinatra'
require 'json'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class User
  include DataMapper::Resource
  property :id,           Serial
  property :username,     String, :required => true
  property :password,     String, :required => true
  property :email,        String
  property :role,         String
  property :member_since, DateTime

  has n, :listing
end

class Listing
  include DataMapper::Resource
  property :id,             Serial
  property :user_id,        String, :required => true
  property :author,         String
  property :title,          String
  property :description,    Text
  property :price,          String
  property :status,         String
  property :last_update,    DateTime

  belongs_to :user
end

DataMapper.finalize

#user register
post '/register' do
  @user = User.new
  @user.username = params[:user][:username]
  @user.email = params[:user][:email]
  @user.password = params[:user][:password]
  @user.role = 'member'
  @user.member_since = Time.now
  #@user.raise_on_save_failure = true
  if @user.save == true
    response = {status: 'success'}
  else
    response = {status: 'error'}
  end
  status 200
  #user.first_or_create
  content_type :json


  body response.to_json
end

#user login
post '/login' do
  user = params[:user]
  username = params[:user][:username]
  password = params[:user][:password]

  if username=='bob' and password == '1234'
    response = {status: 'success'}
  else
    response = {status: 'error'}
  end

  content_type :json

  status 200
  body response.to_json
end

#add new listing
post '/add_listing' do
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
