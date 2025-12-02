# frozen_string_literal: true

class Entity::Block < Entity::Base
  attribute :index, Types::Integer
  attribute :previous_hash, Types::String
  attribute :timestamp, Types::Integer
  attribute :nonce, Types::Integer.default(0)
  attribute :block_hash, Types::String.optional.default(nil)

  attribute :data, Types::Array.of(Types.Instance(Entity::Transaction))

  def mine!(difficulty)
    self.block_hash = loop do
      hash = calculate_hash
      break hash if hash.start_with?("0" * difficulty)

      self.nonce += 1
    end

    self
  end

  def calculate_hash
    Digest::SHA256.hexdigest([index, previous_hash, timestamp, data.join, nonce].join("|"))
  end
end
