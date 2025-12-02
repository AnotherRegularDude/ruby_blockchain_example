# Ruby Blockchain Example
[![CI](https://github.com/AnotherRegularDude/ruby_blockchain_example/actions/workflows/ci.yml/badge.svg)](https://github.com/AnotherRegularDude/ruby_blockchain_example/actions/workflows/ci.yml)
[![Coverage Status](https://coveralls.io/repos/github/AnotherRegularDude/ruby_blockchain_example/badge.svg?branch=main)](https://coveralls.io/github/AnotherRegularDude/ruby_blockchain_example?branch=main)

Educational implementation of core blockchain primitives in Ruby: blocks, transactions, proof-of-work difficulty, chain validation, and service objects.

## Features
- Create the genesis block and initialize the chain via `Case::Blockchain::Create` and `Case::Block::CreateGenesis`.
- Add new blocks with transaction data through `Case::Blockchain::Add`.
- Validate chain integrity and difficulty with `Case::Blockchain::Validate`.
- Typed entities and value objects on dry-struct/dry-types with Zeitwerk autoloading.

## Tech stack
- Ruby 3.4.7
- dry-rb (`dry-struct`, `dry-types`, `dry-initializer`)
- `resol` (service layer)
- `zeitwerk` (autoload)
- `rspec`, `simplecov`/`simplecov-lcov`, `rubocop`, `pry`

## Project structure
```
app/
  case/           # service objects
  entity/         # block, transaction, blockchain entities
  value/          # transaction input/output value objects
config.rb         # dependencies and Zeitwerk setup
spec/             # RSpec tests
```

## Getting started
1. Install Ruby 3.4.7 (rbenv/rvm) and Bundler.
2. Install dependencies:
   ```bash
   bundle install
   ```
3. Run tests:
   ```bash
   bundle exec rspec
   ```

## Usage examples
Create a chain, add a block, and validate:
```ruby
require_relative "config"

input = Value::Transaction::Input.new(transaction_id: "0" * 64, output_index: 0)
output = Value::Transaction::Output.new(address: "demo_wallet", amount: BigDecimal("1.0"))
transaction = Entity::Transaction.build([input], [output])

blockchain = Case::Blockchain::Create.call!

Case::Blockchain::Add.call!(blockchain, [transaction])

valid = Case::Blockchain::Validate.call!(blockchain)
puts "Chain valid? #{valid}"
```

Create a chain with custom difficulty and multiple transactions:
```ruby
require_relative "config"

input1 = Value::Transaction::Input.new(transaction_id: "a" * 64, output_index: 0)
output1 = Value::Transaction::Output.new(address: "alice", amount: BigDecimal("0.5"))
input2 = Value::Transaction::Input.new(transaction_id: "b" * 64, output_index: 1)
output2 = Value::Transaction::Output.new(address: "bob", amount: BigDecimal("0.25"))

transactions = [
  Entity::Transaction.build([input1], [output1]),
  Entity::Transaction.build([input2], [output2]),
]

blockchain = Case::Blockchain::Create.call!(difficulty: 2)
Case::Blockchain::Add.call!(blockchain, transactions)

puts "Blocks in chain: #{blockchain.blocks.size}"
```

## Commands
- Run tests: `bundle exec rspec`
- Coverage report (HTML and LCOV): `COVER=1 bundle exec rspec` (outputs to `coverage/`)
- Lint: `bundle exec rubocop`

## Configuration
- Default mining difficulty is set in `SimpleBlockchain.default_difficulty` (see `config.rb`).
- SimpleCov is enabled when `COVER=1` or `COVER=true` is set in the environment.
