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

describe "GET /heartbeat" do
  before { get '/heartbeat' }
  let(:response) { JSON.parse(last_response.body) }

  it "responds successfully" do
    assert last_response.ok?
  end

  it { response['status'].must_equal 'alive'}
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


# describe "POST /listing" do
#   before do
#     post('/listing', {
#       listing: {
#         title: 'Chronicles of Narnia',
#         author: 'C.S. Lewis',
#         description: 'In great condition',
#         listing_price: '20',
#         owner_id: ''
#       }
#     }, {})
#   end
#
#   let(:response) { JSON.parse(last_response.body) }
#
#   it "should return json" do
#     last_response.headers['Content-Type'].must_equal 'application/json'
#   end
#
#   it "responds successfully" do
#     assert last_response.ok?
#   end
#
#   it { response['status'].must_equal 'success'}
#
# end


describe "POST /user" do
  before do
    post('/user', {

          username: 'jon',
          email: 'jon@test.com',
          password: '1234'

    })
  end

  # let(:response) { JSON.parse(last_response.body) }
  #
  # it "should return json" do
  #   last_response.headers['Content-Type'].must_equal 'application/json'
  # end
  #
  # it "responds successfully" do
  #   assert last_response.ok?
  # end

  # it { response['status'].must_equal 'success'}
  # it { response['user']['username'].must_equal 'bob'}
  # it { response['user']['email'].must_equal 'bob@test.com'}
  # it { response['user']['password'].must_equal '1234'}
end


describe "POST /login" do
  before do
    post('/login', {
        username: 'bob',
        password: '1234'
    })
  end

  let(:response) { JSON.parse(last_response.body) }


  # it "should return json" do
  #   last_response.headers['Content-Type'].must_equal 'application/json'
  # end
  #
  # it "responds successfully" do
  #   assert last_response.ok?
  # end
  #
  # it { response['status'].must_equal 'success'}
end



describe User do
  let(:user) { User.new(username: 'bob', password: '1234', email: 'fola@test.com') }

  it "is an instance of User" do
    assert_instance_of User, user
  end

  it "is a valid User" do
    user.valid?.must_equal true
  end
end

describe Listing do
    let(:listing) { Listing.new(user_id: '1') }

    it "is an instance of Listing" do
      assert_instance_of Listing, listing
    end

    it "is a valid Listing" do
      listing.valid?.must_equal true
    end
end
