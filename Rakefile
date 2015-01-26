require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'dm-validations'
require 'dm-types'
require 'dm-migrations'
require 'dm-sqlite-adapter'
#require 'dm-postgres-adapter'
require 'bcrypt'

DataMapper::Logger.new($stdout, :debug)
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite3://#{Dir.pwd}/development.db")

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


DataMapper.auto_migrate!


task(:default) {
  require_relative 'test'
}
