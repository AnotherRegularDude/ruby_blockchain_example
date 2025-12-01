# frozen_string_literal: true

class Case::Blockchain::Create < Case::Base
  param :difficulty, Types::Integer, default: proc { SimpleBlockchain.default_difficulty }

  def call
    genesis_block = Entity::Block.build_genesis(difficulty)
    blockchain = Entity::Blockchain.new(blocks: [genesis_block], difficulty: difficulty)

    success!(blockchain)
  end
end
