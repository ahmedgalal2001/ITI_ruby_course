require 'date'

module Logger
  def log_info(message)
    log("info", message)
  end

  def log_warning(message)
    log("warning", message)
  end

  def log_error(message)
    log("error", message)
  end

  private

  def log(log_type, message)
    timestamp = DateTime.now.rfc3339
    File.open("app.log", "a") { |file| file.puts("#{timestamp} -- #{log_type} -- #{message}") }
  end
end

class User
  attr_reader :name, :balance

  def initialize(name, balance)
    @name = name
    @balance = balance
  end
end

class Transaction
  attr_reader :user, :value

  def initialize(user, value)
    @user = user
    @value = value
  end
end

class Bank
  def process_transactions(transactions, callback)
    raise NotImplementedError, "Subclasses must implement abstract method"
  end
end

class CBABank < Bank
  include Logger

  BANK_USERS = [
    "ahmed",
    "mohamed",
    "galal"
  ].freeze

  def process_transactions(transactions, callback)
    log_info("Processing Transactions #{transactions.map { |t| "#{t.user.name} transaction with value #{t.value}" }.join(', ')}...")

    transactions.each do |transaction|
      begin
        if BANK_USERS.include?(transaction.user.name)
          raise "Not enough balance" if transaction.user.balance + transaction.value < 0
          transaction.user.balance += transaction.value
          log_info("User #{transaction.user.name} transaction with value #{transaction.value} succeeded")
          log_warning("#{transaction.user.name} has 0 balance") if transaction.user.balance == 0
        else
          raise "#{transaction.user.name} not exist in the bank!!"
        end
        callback.call("success")
      rescue StandardError => e
        log_error("User #{transaction.user.name} transaction with value #{transaction.value} failed with message #{e.message}")
        callback.call("failure")
      end
    end
  end
end

# Example usage
users = [
  User.new("Ali", 200),
  User.new("Peter", 500),
  User.new("Manda", 100)
]

out_side_bank_users = [
  User.new("Menna", 400)
]

transactions = [
  Transaction.new(users[0], -20),
  Transaction.new(users[0], -30),
  Transaction.new(users[0], -50),
  Transaction.new(users[0], -100),
  Transaction.new(users[0], -100),
  Transaction.new(out_side_bank_users[0], -100)
]

bank = CBABank.new
callback = ->(status) { puts "Call endpoint for #{status} of User Ali transaction with value #{transaction.value}" }

bank.process_transactions(transactions, callback)
