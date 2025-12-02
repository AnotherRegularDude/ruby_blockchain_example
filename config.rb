# frozen_string_literal: true

# Standard libraries
require "bigdecimal"
require "digest"
require "time"

# All bundler gems
require "bundler/setup"

Bundler.require(:default)

loader = Zeitwerk::Loader.new
loader.push_dir("app")
loader.setup

module SimpleBlockchain
  module_function

  def default_difficulty = 2
end
