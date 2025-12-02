# frozen_string_literal: true

describe Case::Blockchain::Validate do
  def run!
    described_class.call(blockchain)
  end

  subject(:result) { run! }

  let(:difficulty) { 1 }
  let(:genesis_block) { Case::Block::CreateGenesis.call!(difficulty) }
  let(:blockchain) { Entity::Blockchain.new(blocks: [genesis_block], difficulty:) }

  let(:input) { Value::Transaction::Input.new(transaction_id: "0" * 64, output_index: 0) }
  let(:output) { Value::Transaction::Output.new(address: "some_wallet_address", amount: BigDecimal("0.1")) }
  let(:transaction) { Entity::Transaction.build([input], [output]) }
  let(:timestamp) { Time.now.utc.to_i }
  let(:new_block_data) { [transaction] }

  context "with valid blockchain" do
    before { Case::Blockchain::Add.call!(blockchain, new_block_data) }

    it "returns true for valid blockchain" do
      expect(result).to be_success
      expect(result.value!).to eq(true)
    end
  end

  context "with invalid previous hash" do
    before do
      invalid_block = Entity::Block.new(
        index: 1,
        previous_hash: "invalid_hash",
        timestamp:,
        data: new_block_data,
      ).mine!(difficulty)
      blockchain.add_block!(invalid_block)
    end

    it "returns false for blockchain with invalid previous hash" do
      expect(result).to be_success
      expect(result.value!).to eq(false)
    end
  end

  context "with invalid block hash difficulty" do
    before do
      invalid_block = Entity::Block.new(
        index: blockchain.last_index + 1,
        previous_hash: blockchain.last_hash,
        timestamp:,
        data: new_block_data,
      ).mine!(1)

      blockchain.add_block!(invalid_block)
    end

    let(:difficulty) { 4 }

    it "returns false for blockchain with block not meeting difficulty requirement" do
      expect(result).to be_success
      expect(result.value!).to eq(false)
    end
  end

  context "with tampered block data" do
    before do
      Case::Blockchain::Add.call!(blockchain, new_block_data)
      allow(blockchain.blocks.last.data.first).to receive(:to_s).and_return("invalid id")
    end

    it "returns false for block with tampered data" do
      expect(result).to be_success
      expect(result.value!).to eq(false)
    end
  end

  context "with empty blockchain" do
    let(:blockchain) { Entity::Blockchain.new(blocks: [], difficulty:) }

    it "returns true for empty blockchain" do
      expect(result).to be_success
      expect(result.value!).to eq(true)
    end
  end

  context "with only genesis block" do
    it "returns true for blockchain with only genesis block" do
      expect(result).to be_success
      expect(result.value!).to eq(true)
    end
  end

  context "with invalid blockchain object" do
    let(:blockchain) { "not a blockchain" }

    it "raises TypeError" do
      expect { described_class.call!(blockchain) }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end
