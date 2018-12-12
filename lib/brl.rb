require_relative 'money'
require_relative 'usd'

class BRL < Money
  def initialize(amount: 0, dollar_rate:)
    @name = 'brl'
    @amount = amount
    @symbol = 'R$'
    @description = 'BRL'
    @dollar_rate = dollar_rate
  end

  def cost
    cost = amount / dollar_rate
    USD.new(amount: cost, dollar_rate: dollar_rate)
  end

  def to_usd
    amount / dollar_rate
  end
end
