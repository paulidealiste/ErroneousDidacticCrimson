# frozen_string_literal: true

require_relative 'cli/guide'

# This class library offers cli, IO and retreival methods for the name/surname randomizer that is profspof!
class DubWarehouse
  def initialize
    @cli = CliGuide::Welcome.new
  end

  def run
    @cli.parse
  end
end
