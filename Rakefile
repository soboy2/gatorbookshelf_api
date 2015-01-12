require 'rubygems'
require 'sinatra'
require 'data_mapper'
require 'dm-core'
require 'dm-validations'
require 'dm-types'
require 'dm-migrations'
require 'dm-postgres-adapter'
require 'dm-sqlite-adapter'

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

DataMapper.auto_migrate!


task(:default) {
  require_relative 'test'
}
