require 'terminal-table'

class Transaction
  attr_accessor :id, :operation, :money, :dollar_rate, :status, :message

  def initialize(operation:, money:, dollar_rate:)
    @operation = operation
    @money = money
    @dollar_rate = dollar_rate
    @status = nil
    @message = 'Transação iniciada'
  end

  def to_s
    rows = []
    rows << ['Tipo:', operation]
    rows << ['Quantia:', "#{money.symbol}#{money.amount}"]
    rows << ['Moeda:', money.description]
    rows << ['Cotação:', dollar_rate]
    rows << ['Total:', "U$#{money.to_usd}"]
    Terminal::Table.new :title => "Transação nº #{id}", :rows => rows
  end
end
