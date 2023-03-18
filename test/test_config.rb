# frozen_string_literal: true

require 'minitest/autorun'
require 'minitest/reporters'
require_relative '../lib/config/approvals'

Minitest::Reporters.use!

class ConfigApprovalsTest < Minitest::Test
  def test_scraper_config_correctness
    cfg = ConfigApprovals::Scraper.new
    assert cfg.targets.length.positive? && cfg.targets[0].content[0][:selectors].length.positive?
  end

  def test_database_config
    cfg = ConfigApprovals::Registrar.new
    assert !cfg.path.nil?
  end
end
