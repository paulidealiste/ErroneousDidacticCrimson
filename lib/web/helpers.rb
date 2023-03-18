# frozen_string_literal: true

require_relative '../database/registrar'

# FrontispieceServices hold all the methods used for data retreival for the webapp
module FrontispieceServices
  def self.connect_database
    DatabaseRegistrar::Storage.new
  end

  def self.retreive_random_complement_from_db(db, count)
    db.retreive_random_complement(count)
  end
end
