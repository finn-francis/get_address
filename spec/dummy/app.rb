require 'pry'
require 'sinatra'
require 'sinatra/reloader'

# In the dummy repository there is a file called .env.example
# remove the .example extension and add your api keys and any other environment variables to this file
require 'dotenv/load'

# Use this file to setup your configurations
require './initializers/get_address'

get '/' do
  erb :index
end

post '/find' do
  @address = address_params
  erb :index
end

private

def address_params
  {
    postcode: params[:address][:postcode],
    house:    params[:address][:house]
  }
end
