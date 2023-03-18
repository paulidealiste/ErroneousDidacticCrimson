# frozen_string_literal: true

require_relative '../IO/eager'
require_relative '../database/registrar'

# Module CliHandlers holds corresponding methods for each of the IO cli options chosen
module CliHanlders
  def preconfigured_scraping
    scraper = EagerIO::Scraper.new
    scraper.perform
  end

  def bootstrap_webapp
    webapp_path = File.join(Dir.pwd, 'lib', 'web', 'frontispiece.rb')
    spawn "ruby #{webapp_path}"
  end
end

# CliDatabase holds all the database REPL callable methods
module CliDatabase
  def connect_to_database
    DatabaseRegistrar::Storage.new
  end

  def fill_via_webscraping(db)
    db.fill_via_webscraping
  end

  def call_random_complement(db, count)
    db.retreive_random_complement(count)
  end

  def disconnect_from_database(db)
    db.disconnect
  end

  def read_into_records(path, slug, type, description)
    reader = EagerIO::Reader.new(path)
    reader.read_all
    reader.records_from_read(slug, type, description)
  end

  def fill_from_read_records(db, records)
    db.store_records(records)
  end

  def print_database_stats(db)
    db.print_stats
  end
end
