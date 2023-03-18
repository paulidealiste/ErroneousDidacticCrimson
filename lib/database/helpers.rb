# frozen_string_literal: true

require 'sqlite3'
require_relative '../IO/eager'

require 'pry'

# RegistrarHelpers holds the SQLite-related operations for the names/surnames database.
module RegistrarHelpers
  def predefined_scraping
    scraper = EagerIO::Scraper.new
    scraper.perform
  end

  def create_names_table(db)
    puts 'Creating names table...'
    db.execute <<-SQL
      CREATE TABLE names (
        id integer primary key,
        value varchar(50) UNIQUE,
        slug varchar(10),
        desc varchar(100)
      );
    SQL
  end

  def create_surnames_table(db)
    puts 'Creating surnames table...'
    db.execute <<-SQL
      CREATE TABLE surnames (
        id integer primary key,
        value varchar(50) UNIQUE,
        slug varchar(10),
        desc varchar(100)
      );
    SQL
  end

  def records_to_database(scraped_records, db)
    scraped_records.flatten.each { |record| insert_into_table(record, db) }
  end

  def retreive_random_complement_from_db(db, count)
    names = get_random_names(db, count)
    surnames = get_random_surnames(db, count)
    complements = []
    count.times do |i|
      complements << "#{names[i]['value']} #{surnames[i]['value']}"
    end
    complements
  end

  private

  def get_random_names(db, count)
    db.execute("
      SELECT value
      FROM names
      ORDER BY RANDOM()
      LIMIT ?;
      ", [count])
  end

  def get_random_surnames(db, count)
    db.execute("
      SELECT value
      FROM surnames
      ORDER BY RANDOM()
      LIMIT ?;
      ", [count])
  end

  def get_slug_total_names(db)
    db.execute("
      SELECT slug, COUNT(*)
      FROM names
      GROUP BY slug;
      ")
  end

  def get_slug_total_surnames(db)
    db.execute("
      SELECT slug, COUNT(*)
      FROM surnames
      GROUP BY slug;
      ")
  end

  def insert_into_table(record, db)
    case record.type
    when 'NAMES'
      insert_record_into_names(record, db)
    when 'SURNAMES'
      insert_record_into_surnames(record, db)
    end
  rescue SQLite3::ConstraintException
    puts "Duplicate value found for #{record.content}"
  rescue StandardError
    puts "An unknown error happened when adding #{record.content} to database."
  end

  def insert_record_into_names(record, db)
    db.execute('INSERT INTO names (value, slug, desc) VALUES (?, ?, ?)',
               [record.content, record.slug, record.description])
  end

  def insert_record_into_surnames(record, db)
    db.execute('INSERT INTO surnames (value, slug, desc) VALUES (?, ?, ?)',
               [record.content, record.slug, record.description])
  end
end
