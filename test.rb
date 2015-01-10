#what to test in API
#was the web request successful with right response format?
#was the user directed to right resource?
#was the user successfully authenticated?
#was the correct object sent in the response?
#was the appropriate message sent to user?

ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
require_relative 'gatorbookshelf_api.rb'

include Rack::Test::Methods

def app
  Sinatra::Application
end

describe "Gatorbookshelf API Search" do
  it "should return json" do
    get '/search/lord%20of%20the%20rings'
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "should return a list of potential results for 'lord of the rings'" do
    get '/search/lord%20of%20the%20rings'
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
    results.to_json.must_equal last_response.body
  end


end

describe "Gatorbookshelf API Add" do
  it "should return json" do
    post '/add'
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "should be a success" do
    post '/add'
    #assert_response :success
    last_response.status.must_equal 200
    api_response_body = {action: 'success'}
    api_response_body.to_json.must_equal last_response.body
  end

end

describe "Gatorbookshelf API Register" do
  it "should return json" do
    post '/register'
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "should be a success" do
    post '/register'
    last_response.status.must_equal 200
    api_response_body = {action: 'success'}
    api_response_body.to_json.must_equal last_response.body
  end
end

describe "Gatorbookshelf API login" do
  it "should return json" do
    post '/login'
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "should be a success" do
    post '/login'
    last_response.status.must_equal 200
    api_response_body = {action: 'success'}
    api_response_body.to_json.must_equal last_response.body
  end
end
