# frozen_string_literal: true

class Case::Blockchain::Validate < Case::Base
  param :blockchain, Types.Instance(Entity::Blockchain)

  def call
    return success!(true) if blockchain.blocks.size <= 1

    success!(process_validation)
  end

  private

  attr_accessor :previous_block, :block

  def process_validation
    blockchain.blocks.each_cons(2).all? do |previous_block, block|
      self.previous_block = previous_block
      self.block = block

      valid_previous_hash? && valid_difficulty? && valid_current_hash?
    end
  end

  def valid_previous_hash?
    block.previous_hash == previous_block.block_hash
  end

  def valid_current_hash?
    block.calculate_hash == block.block_hash
  end

  def valid_difficulty?
    block.block_hash.start_with?("0" * blockchain.difficulty)
  end
end
