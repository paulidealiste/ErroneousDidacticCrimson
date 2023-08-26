# frozen_string_literal: true

require_relative 'helpers'

# ConfigApprovals module holds the all app configuration objects in separate classes
module ConfigApprovals
  # Configuration for the web scraper (urls and selectors)
  class ScraperUrlTarget
    attr_accessor :name, :slug, :type, :content

    def initialize(urlcfg)
      @name = urlcfg[:name]
      @slug = urlcfg[:slug]
      @type = urlcfg[:type]
      @content = urlcfg[:content]
    end
  end

  # Configuration for the web scraper (urls and selectors)
  class Scraper
    include ApprovalHelpers
    attr_reader :targets

    def initialize
      config = read_config('scraper')
      @targets = []
      config[:scraper][:targets].each do |target|
        @targets << ScraperUrlTarget.new(target)
      end
    end
  end

  # Configuration for the database
  class Registrar
    include ApprovalHelpers
    attr_reader :path

    def initialize
      config = read_config('database')
      @path = config[:database][:path]
    end
  end
end
