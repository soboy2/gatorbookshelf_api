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

describe "GET /search/:keyword" do
  before { get '/search/lord%20of%20the%20rings' }
  let(:results) { JSON.parse(last_response.body) }

  it "should return json" do
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "responds successfully" do
    assert last_response.ok?
    results[0]['author'].must_equal 'R Tolkein'

  end

  it "returns 2 listings" do
    results.size.must_equal 2
  end
end


describe "POST /add_listing" do
  before do
    post('/add_listing', {
      listing: {
        title: 'Chronicles of Narnia',
        author: 'C.S. Lewis',
        description: 'In great condition',
        listing_price: '20',
        owner_id: ''
      }
    })
  end

  let(:response) { JSON.parse(last_response.body) }

  it "should return json" do
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "responds successfully" do
    assert last_response.ok?
  end

  it { response['status'].must_equal 'success'}
  it { response['listing']['title'].must_equal 'Chronicles of Narnia'}
  it { response['listing']['author'].must_equal 'C.S. Lewis'}
  it { response['listing']['description'].must_equal 'In great condition'}
  it { response['listing']['listing_price'].must_equal '20'}
  it { response['listing']['owner_id'].must_equal 'bob'}

end
# describe "Gatorbookshelf API Add" do
#   it "should return json" do
#     post '/add'
#     last_response.headers['Content-Type'].must_equal 'application/json'
#   end
#
#   it "should be a success" do
#     post '/add'
#     #last_response.status.must_equal 200
#     assert last_response.ok?
#     api_response_body = {status: 'success'}
#     api_response_body.to_json.must_equal last_response.body
#   end
#
# end

describe "POST /register" do
  before do
    post('/register', {
      user: {
          user_id: 'bob',
          email: 'bob@test.com',
          password: '1234'
      }
    })
  end

  let(:response) { JSON.parse(last_response.body) }

  it "should return json" do
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "responds successfully" do
    assert last_response.ok?
  end

  it { response['status'].must_equal 'success'}
  it { response['user']['user_id'].must_equal 'bob'}
  it { response['user']['email'].must_equal 'bob@test.com'}
  it { response['user']['password'].must_equal '1234'}
end


describe "POST /login" do
  before do
    post('/login', {
      user: {
        user_id: 'bob',
        password: '1234'
      }
    })
  end

  let(:response) { JSON.parse(last_response.body) }

  it "should return json" do
    last_response.headers['Content-Type'].must_equal 'application/json'
  end

  it "responds successfully" do
    assert last_response.ok?
  end

  it { response['status'].must_equal 'success'}
end


# describe "Creating a User record" do
#   it "shoud create a user" do
#     user = User.create(user_id: 'sho', password: '1234')
#     assert user.valid?, 'The user was not valid'
#   end
# end
