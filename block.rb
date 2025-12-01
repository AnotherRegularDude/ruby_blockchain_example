# frozen_string_literal: true

require "digest"
require "time"

class Block
  attr_reader :index, :previous_hash, :timestamp, :data, :hash, :nonce

  class << self
    def build_initial_block
      new(0, "0", ["Initial block"])
    end
  end

  def initialize(index, previous_hash, data, timestamp = nil)
    @index = index
    @previous_hash = previous_hash
    @timestamp = timestamp || Time.now.utc.to_i
    @data = data
    @nonce = 0
    @hash = calculate_hash!
  end

  private

  def calculate_hash!
    Digest::SHA256.hexdigest([@index, @previous_hash, @timestamp, @data.join, @nonce].join)
  end
end
