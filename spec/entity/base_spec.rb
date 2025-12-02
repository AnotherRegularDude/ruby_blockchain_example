# frozen_string_literal: true

describe Entity::Base do
  let(:entity_class) do
    Class.new(described_class) do
      def age=(_)
        "Not overridden"
      end

      attribute :name, Types::String
      attribute :age, Types::Integer

      def update_name!(new_name)
        self.name = new_name
      end
    end
  end

  let(:name) { "just_man" }
  let(:age) { 27 }

  context "with inherited entity class" do
    it "defines a setter for the attribute with validation" do
      entity = entity_class.new(name: name, age: age)

      expect(entity.name).to eq("just_man")
      expect(entity.age).to eq(27)

      entity.update_name!("just_woman")
      expect(entity.name).to eq("just_woman")
      expect(entity.send(:age=, 1)).to eq("Not overridden")

      expect { entity.update_name!(47) }.to raise_error(Dry::Struct::Error, "47 (:name) has an invalid type")
    end
  end
end
