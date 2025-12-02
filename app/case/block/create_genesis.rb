# frozen_string_literal: true

class Case::Block::CreateGenesis < Case::Base
  param :difficulty, Types::Integer

  def call
    genesis_input = Value::Transaction::Input.new(transaction_id: "0" * 64, output_index: 0)
    genesis_output = Value::Transaction::Output.new(address: "genesis_wallet", amount: BigDecimal("0"))
    genesis_transaction = Entity::Transaction.build([genesis_input], [genesis_output])

    block = Entity::Block.new(
      index: 0,
      previous_hash: "0" * 64,
      timestamp: Time.now.utc.to_i,
      data: [genesis_transaction],
    ).mine!(difficulty)

    success!(block)
  end
end
