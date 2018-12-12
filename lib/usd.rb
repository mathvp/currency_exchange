require_relative 'money'
require_relative 'brl'

class USD < Money
  def initialize(amount: 0, dollar_rate:)
    @name = 'usd'
    @amount = amount
    @symbol = 'U$'
    @description = 'USD'
    @dollar_rate = dollar_rate
  end

  def cost
    cost = amount * dollar_rate
    BRL.new(amount: cost, dollar_rate: dollar_rate)
  end

  def to_usd
    amount
  end
end
