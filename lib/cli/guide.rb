# frozen_string_literal: true

require 'optparse'
require_relative './helpers'

# CliGuide module exposes the cli user interface for all the database operations and data retreival
module CliGuide
  # Declared file not found error for the Eager IO module
  class UnknownParameter < RuntimeError; end

  # Welcome options and initial app methods
  class Welcome
    include CliHanlders
    def parse
      @options = {}
      OptionParser.new do |opts|
        opts.banner = 'Hello and welcome. This app is used like profspof [options].'
        on_wsc(opts)
        on_csv(opts)
        on_db(opts)
        on_web(opts)
      end.parse!
      act_on_options
    end

    private

    def act_on_options
      @options.each do |key, value|
        case key
        when :scrape
          preconfigured_scraping if value == true
        when :csv
          p 'csv stub!'
        when :database
          DatabaseRepl.new.run if value == true
        when :webapp
          bootstrap_webapp if value == true
        else
          raise UnknownParameter
        end
      end
    end

    def on_help(opts)
      opts.on('-h', '--help', 'Prints this help') do
        puts opts
        exit
      end
    end

    def on_wsc(opts)
      opts.on('-s', '--scrape', 'Web scraping from the pre-configured targers to stdout.') do
        @options[:scrape] = true
      end
    end

    def on_csv(opts)
      opts.on('-c', '--csv=PATH', 'Read in one csv data file from the specified PATH to stdout.') do |path|
        @options[:csv] = path
      end
    end

    def on_db(opts)
      opts.on('-d', '--database', 'Start simplified database REPL.') do
        @options[:database] = true
      end
    end

    def on_web(opts)
      opts.on('-w', '--webapp', 'Start dedicated localhost webapp.') do
        @options[:webapp] = true
      end
    end
  end

  # Database REPL
  class DatabaseRepl
    include CliDatabase

    def initialize
      @db = nil
    end

    def run
      welcome_mesage
      repl
      farewell_message
    end

    private

    def welcome_mesage
      puts 'Database REPL offers a simplified interface for operating the names/surnames database.'
      puts 'The following commands are available:'
      help_message
      puts 'Please note that database should be connected or created first.'
    end

    def repl
      loop do
        print "[#{Time.new.strftime('%Y/%m/%d %k:%M:%S')}#{' c' if @db}] >> "
        prompt = gets.chomp
        case prompt
        when 'connect'
          @db = connect_to_database
          puts 'An instance of the database has been connected.'
        when 'from_scrape'
          repl_from_scrape
        when /retreive [0-9]+$/
          repl_retreive(prompt[/[0-9]+$/].to_i)
        when /from_csv (([^ ]+)\s{1})(\w+)(\s{1})(\w+)(\s{1})(\w+)/
          repl_from_csv(prompt)
        when 'help'
          help_message
        when 'stats'
          repl_stats
        when 'quit'
          break unless @db

          disconnect_from_database(@db)
        else
          puts 'Not implemented, unknown or just plain bad command.'
        end
      end
    end

    def farewell_message
      puts 'Goodbye and thanks for all the fish!'
    end

    def not_connected_message
      puts 'Connect to a database first.'
    end

    def help_message
      puts 'connect - connects to an existing or creates a new database'
      puts 'from_scrape - perform web scraping with preconfigured targerts and store the the results'
      puts 'from_csv [path slug description] - read csv file and store the results as NAMES or SURNAMES'
      puts 'retreive [n] - retreive n randomized name/surname pairs'
      puts 'stats - print some database statistics'
      puts 'quit - quit this repl and disconnect from the database'
      puts 'help - prints this help'
    end

    def repl_from_scrape
      if @db
        fill_via_webscraping(@db)
      else
        not_connected_message
      end
    end

    def repl_from_csv(prompt)
      _, path, slug, type, description = prompt.split
      if @db
        records = read_into_records(path, slug, type, description)
        fill_from_read_records(@db, records)
      else
        not_connected_message
      end
    end

    def repl_retreive(count)
      if @db
        call_random_complement(@db, count)
      else
        not_connected_message
      end
    end

    def repl_stats
      if @db
        print_database_stats(@db)
      else
        not_connected_message
      end
    end
  end
end
