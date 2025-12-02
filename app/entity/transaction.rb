# frozen_string_literal: true

class Entity::Transaction < Entity::Base
  attribute :id, Types::String.optional.default(nil)
  attribute :inputs, Types::Array.of(Types.Instance(Value::Transaction::Input)).constrained(min_size: 1)
  attribute :outputs, Types::Array.of(Types.Instance(Value::Transaction::Output)).constrained(min_size: 1)

  def self.build(inputs, outputs)
    new(inputs:, outputs:).calculate_id!
  end

  def calculate_id!
    self.id ||= Digest::SHA256.hexdigest([inputs, outputs].flatten.join("|"))
    self
  end

  alias to_s id
end
