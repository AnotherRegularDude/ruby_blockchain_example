# frozen_string_literal: true

class Value::Transaction::Output < Value::Base
  attribute :address, Types::String
  attribute :amount, Types::Decimal.constrained(gteq: BigDecimal("0"))

  def to_s
    "#{address}:#{amount}"
  end
end
