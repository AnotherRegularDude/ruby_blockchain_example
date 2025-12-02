# frozen_string_literal: true

class Entity::Blockchain < Entity::Base
  attribute :blocks, Types::Array.of(Types.Instance(Entity::Block))
  attribute :difficulty, Types::Integer

  def last_index
    blocks.last.index
  end

  def last_hash
    blocks.last.block_hash
  end

  def add_block!(block)
    blocks << block
  end
end
