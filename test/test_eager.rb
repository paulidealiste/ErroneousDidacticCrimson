# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/IO/eager'

Minitest::Reporters.use!

# Test a the inputs functionality
class EagerIOTest < Minitest::Test
  def test_reader_initialization
    f = EagerIO::Reader.new('Seed/NamesFeed.csv')
    f.read_all
    f.close_file
    assert !f.contents.nil?
  end

  def test_reader_error
    assert_raises(EagerIO::FileNotFound) { EagerIO::Reader.new('') }
  end

  def test_scraper_error
    scraper = EagerIO::Scraper.new
    assert_raises(EagerIO::UrlError) { scraper.scrape({ address: '', selectors: '', regexp: '' }, '', '', '') }
  end

  def test_scraper_selectors
    scraper = EagerIO::Scraper.new
    dom = scraper.html_parser('<html><body><div class="mw-category-group">Test drive</div></body></html>')
    selectors = ['.mw-category-group']
    content = scraper.apply_selectors(dom, selectors)[0]
    assert content == 'Test drive'
  end

  def test_scraper_regex
    scraper = EagerIO::Scraper.new
    content = ['morph (aplicative)']
    test = scraper.apply_regexp(content, '^\S*')[0]
    assert_equal('morph', test[0])
  end

  def test_create_records_scraper
    scraper = EagerIO::Scraper.new
    scraped = %w[Deafheaven WhiteWard]
    slug = 'bmt'
    type = 'BLACKGAZE'
    description = 'One of the newer genres'
    records = scraper.create_records(scraped, slug, type, description)
    assert_includes(records, EagerIO::Scraper::EagerRecord.new('Deafheaven', slug, type, description))
  end

  def test_create_records_reader
    f = EagerIO::Reader.new('Seed/NamesFeed.csv')
    slug = 'tty'
    type = 'ytt'
    description = 'tyt'
    f.read_all
    records = f.records_from_read(slug, type, description)
    f.close_file
    assert_includes(records, EagerIO::Scraper::EagerRecord.new('Aca', slug, type, description))
  end
end
