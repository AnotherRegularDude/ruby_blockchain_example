# frozen_string_literal: true

class Entity::Base < Dry::Struct
  transform_keys(&:to_sym)

  class << self
    def attribute(name, type, ...)
      super
      define_setter(name, type)
    end

    private

    def define_setter(name, type)
      method_name = :"#{name}="
      return if method_defined?(method_name)

      define_method(method_name) do |value|
        raise Dry::Struct::Error, "#{value.inspect} (:#{name}) has an invalid type" unless type.valid?(value)

        attributes[name] = value
      end
      private(method_name)
    end
  end
end
