# frozen_string_literal: true

class Case::Blockchain::Add < Case::Base
  param :blockchain, Types.Instance(Entity::Blockchain)
  param :data, Types::Array

  def call
    self.block = create_block!
    add_block!
    success!
  end

  private

  attr_accessor :block

  def create_block!
    Entity::Block.new(
      index: blockchain.last_index + 1,
      previous_hash: blockchain.last_hash,
      timestamp: Time.now.utc.to_i,
      data:,
    ).mine!(blockchain.difficulty)
  end

  def add_block!
    blockchain.add_block!(block)
  end
end
