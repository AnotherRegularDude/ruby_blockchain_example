# frozen_string_literal: true

class Entity::Block < Entity::Base
  attribute :index, Types::Integer
  attribute :previous_hash, Types::String
  attribute :timestamp, Types::Integer

  attribute :data, Types::Array

  attribute :nonce, Types::Integer.default(0)
  attribute :block_hash, Types::String.optional.default(nil)

  def self.build_genesis(difficulty)
    new(index: 0, previous_hash: "0" * 64, timestamp: Time.now.utc.to_i, data: ["Initial block"]).mine!(difficulty)
  end

  def mine!(difficulty)
    self.block_hash = loop do
      hash = calculate_hash
      break hash if hash.start_with?("0" * difficulty)

      self.nonce += 1
    end

    self
  end

  private

  def calculate_hash
    Digest::SHA256.hexdigest([index, previous_hash, timestamp, data.join, nonce].join("|"))
  end
end
