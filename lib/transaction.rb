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
    msg =  "\nTransação nº #{id}\n"
    msg << "Tipo: #{operation}\n"
    msg << "Quantia: #{money.symbol}#{money.amount}\n"
    msg << "Moeda: #{money.description}\n"
    msg << "Cotação: #{dollar_rate}\n"
    msg << "Total: U$#{money.to_usd}\n"
    msg
  end
end
