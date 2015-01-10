require 'sinatra'
require 'json'
require 'data_mapper'

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

class User
  include DataMapper::Resource
  property :id,           Serial
  property :user_id,      String, :required => true
  property :password,     String, :required => true
  property :email,        String
  property :member_since, DateTime

  has n, :listing
end

class Listing
  include DataMapper::Resource
  property :id,             Serial
  #property :owner_id,       String, :required => true
  property :author,         String
  property :title,          String
  property :description,    Text
  property :price,          String
  property :status,         String
  property :last_update,    DateTime

  belongs_to :user
end

DataMapper.finalize

post '/register' do
  content_type :json
  response = {action: 'success'}
  status 200
  body response.to_json
end

post '/login' do
  content_type :json
  response = {action: 'success'}
  status 200
  body response.to_json
end


post '/add' do
  content_type :json

  @author = params[:author]
  @title = params[:title]
  @description = params[:description]
  @listing_price = params[:listing_price]
  @owner_id = params[:owner_id] #need to get this from session

  response = {action: 'success'}

  status 200
  body response.to_json
end

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
        owner_id: 2,
        listing_price: 33
      },
      {
        author: "R Tolkein",
        title: "Lord of the rings: Fellowship of the Ring",
        last_update: "2015-02-06T10:30:00Z",
        description: "Looks great",
        listing_id: 2,
        owner_id: 3,
        listing_price: 30
      }
    ]

  else
    results = {error: 'no matches found'}
  end
  results.to_json
end
