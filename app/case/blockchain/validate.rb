# frozen_string_literal: true

class Case::Blockchain::Validate < Case::Base
  param :blockchain, Types.Instance(Entity::Blockchain)

  def call
    return success!(true) if blockchain.blocks.size <= 1

    success!(process_validation)
  end

  private

  def process_validation
    blockchain.blocks.each_cons(2).all? do |previous_block, block|
      block.previous_hash == previous_block.block_hash && block.block_hash.start_with?("0" * blockchain.difficulty)
    end
  end
end
