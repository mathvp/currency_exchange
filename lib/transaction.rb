require 'terminal-table'
require 'sqlite3'

class Transaction
  attr_accessor :operation, :money, :dollar_rate, :message

  def initialize(operation:, money:, dollar_rate:)
    @operation = operation
    @money = money
    @dollar_rate = dollar_rate
    @message = 'Transação iniciada'
  end

  def save
    db = SQLite3::Database.open 'cambio.db'
    sql_insert =  "insert into transactions"
    sql_insert << "(operation, amount, currency, dollar_rate, total) values"
    sql_insert << "('#{operation}', #{money.amount}, '#{money.description}', #{dollar_rate}, #{money.to_usd});"
    db.execute(sql_insert)
  end  
end
