# frozen_string_literal: true

require 'httparty'
require 'nokogiri'

# EagerHelpers module holds the auxilliary functions and datatypes for Eager module IO
module EagerHelpers
  EagerRecord = Struct.new(:content, :slug, :type, :description)

  def http_content(url, &block)
    response = HTTParty.get(url)
    block.call(response.body)
  rescue StandardError
    block.call(nil)
  end

  def html_parser(html)
    Nokogiri::HTML(html)
  end

  def apply_selectors(dom, selectors)
    selectors.flat_map do |selector|
      selected = dom.css(selector)
      selected.children.collect(&:text)
    end
  end

  def apply_regexp(content, regexp)
    content.collect { |text| text.scan(Regexp.new(regexp)) }
  end

  def create_records(content, slug, type, description)
    content.flatten.collect { |scraped| EagerRecord.new(scraped, slug, type, description) }
  end
end
