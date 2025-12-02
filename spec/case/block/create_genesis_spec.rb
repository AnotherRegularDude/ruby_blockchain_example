# frozen_string_literal: true

describe Case::Block::CreateGenesis do
  def run!
    described_class.call!(difficulty)
  end

  subject(:block) { run! }

  let(:difficulty) { 2 }
  let(:timestamp) { Time.now.utc.to_i }

  context "with valid difficulty" do
    it "creates a valid genesis block" do
      expect(block).to be_a(Entity::Block)
      expect(block.index).to eq(0)
      expect(block.previous_hash).to eq("0" * 64)
      expect(block.timestamp).to be_a(Integer)
      expect(block.data).to be_a(Array)
      expect(block.data.size).to eq(1)
      expect(block.data.first).to be_a(Entity::Transaction)
      expect(block.block_hash).to start_with("0" * difficulty)
      expect(block.nonce).to be_an(Integer)
    end

    it "creates a genesis transaction with correct data" do
      genesis_transaction = block.data.first
      expect(genesis_transaction.inputs.size).to eq(1)
      expect(genesis_transaction.outputs.size).to eq(1)

      input = genesis_transaction.inputs.first
      expect(input.transaction_id).to eq("0" * 64)
      expect(input.output_index).to eq(0)

      output = genesis_transaction.outputs.first
      expect(output.address).to eq("genesis_wallet")
      expect(output.amount).to eq(BigDecimal("0"))
    end
  end

  context "with zero difficulty" do
    let(:difficulty) { 0 }

    it "creates a genesis block with any hash" do
      expect(block.block_hash.empty?).to eq(false)
    end
  end

  context "with high difficulty" do
    let(:difficulty) { 4 }

    it "creates a genesis block with hash meeting difficulty requirement" do
      expect(block.block_hash).to start_with("0" * difficulty)
    end
  end

  context "with negative difficulty" do
    let(:difficulty) { -1 }

    it "raises ArgumentError" do
      expect { block }.to raise_error(ArgumentError)
    end
  end

  context "with non-integer difficulty" do
    let(:difficulty) { "invalid" }

    it "raises TypeError" do
      expect { run! }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end
