# frozen_string_literal: true

require 'sinatra'
require_relative './helpers'

set :views, 'lib/web/views'

get '/' do
  db = FrontispieceServices.connect_database
  @complements = FrontispieceServices.retreive_random_complement_from_db(db, 10)
  erb :index
end
