# frozen_string_literal: true

describe Case::Blockchain::Add do
  def run!
    described_class.call!(blockchain, data)
  end

  let(:difficulty) { 1 }
  let(:genesis_block) { Case::Block::CreateGenesis.call!(difficulty) }
  let(:blockchain) { Entity::Blockchain.new(blocks: [genesis_block], difficulty:) }

  let(:input) { Value::Transaction::Input.new(transaction_id: "0" * 64, output_index: 0) }
  let(:output) { Value::Transaction::Output.new(address: "some_wallet_address", amount: BigDecimal("0.1")) }
  let(:transaction) { Entity::Transaction.build([input], [output]) }
  let(:data) { [transaction] }

  let(:new_block) { blockchain.blocks.last }

  context "with valid parameters" do
    it "adds a new block to the blockchain" do
      run!

      expect(blockchain.blocks.size).to eq(2)
      expect(new_block.index).to eq(1)
      expect(new_block.previous_hash).to eq(genesis_block.block_hash)
      expect(new_block.data).to eq(data)
      expect(new_block.block_hash).to start_with("0" * difficulty)
      expect(new_block.nonce).to be_an(Integer)
      expect(new_block.timestamp).to be_a(Integer)
    end
  end

  context "with multiple data entries" do
    let(:transaction1) { Entity::Transaction.build([input], [output]) }
    let(:transaction2) { Entity::Transaction.build([input], [output]) }
    let(:transaction3) { Entity::Transaction.build([input], [output]) }
    let(:data) { [transaction1, transaction2, transaction3] }

    it "creates block with all data entries" do
      run!

      expect(blockchain.blocks.size).to eq(2)
      expect(new_block.data.size).to eq(3)
    end
  end

  context "with empty data array" do
    let(:data) { [] }

    it "creates block with empty data" do
      run!

      expect(blockchain.blocks.size).to eq(2)
      expect(new_block.data).to eq([])
    end
  end

  context "with invalid blockchain" do
    let(:blockchain) { "not a blockchain" }

    it "raises TypeError" do
      expect { run! }.to raise_error(Dry::Types::ConstraintError)
    end
  end

  context "with invalid data type" do
    let(:data) { "not an array" }

    it "raises TypeError" do
      expect { run! }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end
