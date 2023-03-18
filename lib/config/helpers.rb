# frozen_string_literal: true

require 'yaml'

# ApprovalHelpers holds helper methods for reading and parsing configuration files
module ApprovalHelpers
  def read_config(filename)
    path = File.join(Dir.pwd, 'lib', 'config', "#{filename}.yml")
    YAML.safe_load(File.read(path), symbolize_names: true)
  end
end
