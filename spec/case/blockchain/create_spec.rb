# frozen_string_literal: true

describe Case::Blockchain::Create do
  def run!
    described_class.call!(*[difficulty].compact)
  end

  subject(:blockchain) { run! }

  let(:difficulty) { 1 }
  let(:genesis_block) { blockchain.blocks.first }

  describe "with specified difficulty" do
    it "creates valid blockchain" do
      expect(blockchain).to be_a(Entity::Blockchain)
      expect(blockchain.blocks.size).to eq(1)
      expect(blockchain.difficulty).to eq(1)

      # Проверки генезис-блока
      expect(genesis_block.index).to eq(0)
      expect(genesis_block.previous_hash).to eq("0" * 64)
      expect(genesis_block.data).to be_a(Array)
      expect(genesis_block.data.first).to be_a(Entity::Transaction)
      expect(genesis_block.block_hash).to start_with("0" * difficulty)
      expect(genesis_block.nonce).to be_an(Integer)
      expect(genesis_block.timestamp).to be_a(Integer)
    end
  end

  context "with default difficulty" do
    before { allow(SimpleBlockchain).to receive(:default_difficulty).and_return(2) }

    let(:difficulty) { nil }

    it "creates blockchain with default difficulty" do
      expect(blockchain.difficulty).to eq(2)
      expect(genesis_block.block_hash).to start_with("0" * 2)
    end
  end

  context "with minimum difficulty" do
    let(:difficulty) { 0 }

    it "creates blockchain with difficulty 0" do
      expect(blockchain.difficulty).to eq(0)
      expect(genesis_block.block_hash.empty?).to eq(false)
    end
  end

  context "with more hardest difficulty" do
    let(:difficulty) { 3 }

    it "creates blockchain with specified difficulty" do
      expect(blockchain.difficulty).to eq(3)
      expect(genesis_block.block_hash).to start_with("0" * 3)
    end
  end

  context "with negative difficulty" do
    let(:difficulty) { -1 }

    it "raises ArgumentError" do
      expect { blockchain }.to raise_error(ArgumentError)
    end
  end

  context "with non-integer difficulty" do
    let(:difficulty) { "invalid" }

    it "raises ArgumentError" do
      expect { run! }.to raise_error(Dry::Types::ConstraintError)
    end
  end
end
