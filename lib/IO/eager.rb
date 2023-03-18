# frozen_string_literal: true

require_relative './helpers'
require_relative '../config/approvals'

# EagerIO module holds the all the I/O methods including web scraping
module EagerIO
  # Declared file not found error for the Eager IO module
  class FileNotFound < RuntimeError; end
  # Declared url error for the Eager IO module
  class UrlError < StandardError; end

  # Reads in the data from plain text files and csvs
  class Reader
    include EagerHelpers
    attr_reader :contents

    def initialize(path)
      raise FileNotFound unless File.exist?(path)

      path = File.expand_path(path)
      @handle = File.new(path, 'r')
    end

    def read_line
      @handle.gets
    end

    def read_all
      @contents = []
      @handle.each { |line| contents << line.strip }
    end

    def records_from_read(*metadata)
      slug, type, description = metadata
      create_records(@contents, slug, type, description)
    end

    def close_file
      @handle.close
    end
  end

  # Web scaping for content
  class Scraper
    include EagerHelpers
    include Enumerable
    def initialize
      @config = ConfigApprovals::Scraper.new
    end

    def perform
      @scraped = @config.targets.flat_map do |target|
        target.content.collect do |target_content|
          scrape(target_content, target.slug, target.type, target.name).flatten
        end
      end
      @scraped
    end

    def scrape(target_content, slug, type, description)
      target_content => { address:, selectors:, regexp: } # from Ruby 3.0 rightward assignment
      http_content(address) do |response|
        raise UrlError if response.nil?

        contents = parse_and_select(response, selectors)
        processed_contents = process_selected(contents, regexp)
        puts "Found #{processed_contents.length} for a slug #{slug} with description #{description}."
        records_from_scraped(processed_contents, slug, type, description)
      end
    end

    private

    def parse_and_select(response, selectors)
      dom = html_parser(response)
      apply_selectors(dom, selectors)
    end

    def process_selected(content, regexp)
      apply_regexp(content, regexp)
    end

    def records_from_scraped(processed_contents, slug, type, description)
      create_records(processed_contents, slug, type, description)
    end
  end
end
