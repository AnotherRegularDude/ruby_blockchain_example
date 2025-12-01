# frozen_string_literal: true

class Case::Blockchain::Validate < Case::Base
  param :blockchain, Types.Instance(Entity::Blockchain)

  def call
    valid = blockchain.blocks[1..].all? do |block|
      previous_block = blockchain.blocks[block.index - 1]
      block.previous_hash == previous_block.block_hash && block.block_hash.start_with?("0" * blockchain.difficulty)
    end

    success!(valid)
  end
end
