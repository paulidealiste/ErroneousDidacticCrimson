# frozen_string_literal: true

require 'sqlite3'
require_relative './helpers'
require_relative '../config/approvals'

# DatabaseRegistrar is a module for all database operations
module DatabaseRegistrar
  # Main database class for storage of the name/surname records
  class Storage
    include RegistrarHelpers
    def initialize
      config = ConfigApprovals::Registrar.new
      puts 'Databese initialization...'
      if File.exist?(config.path)
        @db = SQLite3::Database.open(config.path)
      else
        @db = SQLite3::Database.new(config.path)
        create_tables
      end
      @db.results_as_hash = true
    end

    def fill_via_webscraping
      scraped_records = predefined_scraping
      records_to_database(scraped_records)
    end

    def store_records(records)
      records_to_database(records, @db)
    end

    def print_stats
      get_slug_total_names(@db).each do |strw|
        print_stat_row(strw)
      end
      get_slug_total_surnames(@db).each do |strw|
        print_stat_row(strw)
      end
    end

    def retreive_random_complement(count)
      complements = retreive_random_complement_from_db(@db, count)
      complements.each { |complement| puts complement }
    end

    def disconnect
      @db.close
      exit
    end

    private

    def create_tables
      create_names_table(@db)
      create_surnames_table(@db)
    end

    def print_stat_row(db_row)
      puts "#{db_row.values[0]}: #{db_row.values[1]}"
    end
  end
end
