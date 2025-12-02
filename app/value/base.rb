# frozen_string_literal: true

class Value::Base < Dry::Struct
  transform_keys(&:to_sym)
end
