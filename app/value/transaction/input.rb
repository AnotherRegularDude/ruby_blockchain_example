# frozen_string_literal: true

class Value::Transaction::Input < Value::Base
  attribute :transaction_id, Types::String
  attribute :output_index, Types::Integer

  def to_s
    "#{transaction_id}:#{output_index}"
  end
end
