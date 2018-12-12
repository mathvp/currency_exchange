require_relative 'transaction'
require_relative 'usd'
require_relative 'brl'

class CashRegister
  attr_accessor :transactions, :dollar_rate, :available_cash

  def initialize(dollar_rate:, usd_amount:, brl_amount:)
    @dollar_rate = dollar_rate
    @available_cash = {
      'usd' => USD.new(amount: usd_amount, dollar_rate: dollar_rate),
      'brl' => BRL.new(amount: brl_amount, dollar_rate: dollar_rate)
    }
    @transactions = []
  end

  def buy(money)
    return "#{money.cost.description} insuficiente para essa operação" unless can_buy?(money)

    puts "Custo da operação: #{money.cost.symbol} #{money.cost.amount}"
    return 'Operação cancelada' unless confirm?('Deseja realizar a transação?')

    available_cash[money.cost.name].amount -= money.cost.amount
    available_cash[money.name].amount += money.amount
    transactions << create_transaction('Compra', money)
    export_last_transaction
    transactions.last.message
  end

  def sell(money)
    return "#{money.description} insuficiente para essa operação" unless can_sell?(money)

    puts "Rendimento da operação: #{money.cost.symbol} #{money.cost.amount}"
    return 'Operação cancelada' unless confirm?('Deseja realizar a transação?')

    available_cash[money.name].amount -= money.amount
    available_cash[money.cost.name].amount += money.cost.amount
    transactions << create_transaction('Venda', money)
    export_last_transaction
    transactions.last.message
  end

  def summary
    rows =  []
    rows << ['Cotação dóllar:', dollar_rate]
    rows << ['Valores disponíveis:', nil]
    available_cash.each do |cash|
      rows << ["#{cash[1].description}:", "#{cash[1].symbol} #{cash[1].amount}"]
    end
    Terminal::Table.new :title => "Situação do Caixa", :rows => rows
  end

  def export_last_transaction
    File.open('transactions.txt', 'a') do |file|
      file.puts transactions.last.to_s
    end
  end

  private

  def create_transaction(operation, money)
    transaction = Transaction.new(
      operation: operation,
      money: money,
      dollar_rate: dollar_rate
    )
    transaction.id = ++transactions.length
    transaction.message = "#{operation} de #{money.symbol} #{money.amount} realizada!"    
    transaction
  end

  def can_buy?(money)
    currency = money.cost.name
    available_cash[currency].amount - money.cost.amount >= 0
  end

  def can_sell?(money)
    available_cash[money.name].amount - money.amount >= 0
  end

  def confirm?(question)
    option = ''
    loop do
      print "#{question} (s/n): "
      option = gets.chomp.downcase
      break unless option != 's' && option != 'n'

      puts 'Opção inválida!'
    end
    option == 's'
  end
end
