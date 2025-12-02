# frozen_string_literal: true

describe Entity::Transaction do
  subject(:transaction) { described_class.build(inputs, outputs) }

  let(:inputs) { [input] }
  let(:input) { Value::Transaction::Input.new(transaction_id: "0" * 64, output_index: 0) }
  let(:outputs) { [output] }
  let(:output) { Value::Transaction::Output.new(address: "some_wallet_address", amount: BigDecimal("0.1")) }

  context "when new transaction are built" do
    let(:expected_transaction_id) { "809d7b433611e9614857f6647132b04db9478810840416ba5c9ac5db91628b00" }

    it "creates a new transaction with the correct id, inputs and outputs" do
      expect(transaction.id).to eq(expected_transaction_id)

      expect(transaction.inputs.size).to eq(1)
      expect(transaction.inputs.first).to be_a(Value::Transaction::Input)
      expect(transaction.inputs.first.transaction_id).to eq("0" * 64)
      expect(transaction.inputs.first.output_index).to eq(0)

      expect(transaction.outputs.size).to eq(1)
      expect(transaction.outputs.first).to be_a(Value::Transaction::Output)
      expect(transaction.outputs.first.address).to eq("some_wallet_address")
      expect(transaction.outputs.first.amount).to eq(BigDecimal("0.1"))
    end
  end

  context "with multiple inputs and outputs" do
    let(:expected_transaction_id) { "e4fa40425e82357e636f0e74937c7338fade9adade22a65d92d68f2eb37787b7" }

    let(:inputs) do
      [
        Value::Transaction::Input.new(transaction_id: "0" * 64, output_index: 0),
        Value::Transaction::Input.new(transaction_id: "1" * 64, output_index: 1),
      ]
    end
    let(:outputs) do
      [
        Value::Transaction::Output.new(address: "address1", amount: BigDecimal("0.5")),
        Value::Transaction::Output.new(address: "address2", amount: BigDecimal("0.3")),
      ]
    end

    it "creates transaction with multiple inputs and outputs" do
      expect(transaction.id).to eq(expected_transaction_id)

      expect(transaction.inputs.size).to eq(2)
      expect(transaction.outputs.size).to eq(2)
      expect(transaction.inputs.map(&:transaction_id)).to eq(["0" * 64, "1" * 64])
      expect(transaction.outputs.map(&:address)).to eq(%w[address1 address2])
    end
  end

  context "with empty inputs" do
    let(:inputs) { [] }
    let(:part_of_error_message) { "has invalid type for :inputs violates constraints" }

    it "raises an error" do
      expect { transaction }.to raise_error(Dry::Struct::Error, a_string_including(part_of_error_message))
    end
  end

  context "with empty outputs" do
    let(:outputs) { [] }
    let(:part_of_error_message) { "has invalid type for :outputs violates constraints" }

    it "raises an error" do
      expect { transaction }.to raise_error(Dry::Struct::Error, a_string_including(part_of_error_message))
    end
  end

  context "with invalid input type" do
    let(:inputs) { ["invalid"] }

    it "raises a type error" do
      expect { transaction }.to raise_error(Dry::Struct::Error)
    end
  end

  context "with invalid output type" do
    let(:outputs) { ["invalid"] }

    it "raises a type error" do
      expect { transaction }.to raise_error(Dry::Struct::Error)
    end
  end

  context "with negative amount" do
    let(:output) { Value::Transaction::Output.new(address: "address", amount: BigDecimal("-0.1")) }

    it "raises an error for negative amount" do
      expect { transaction }.to raise_error(Dry::Struct::Error)
    end
  end
end
