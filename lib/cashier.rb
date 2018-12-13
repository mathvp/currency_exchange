require_relative 'transaction'
require_relative 'usd'
require_relative 'brl'
require 'terminal-table'
require 'sqlite3'

class Cashier
  attr_accessor :dollar_rate, :available_cash

  def initialize(dollar_rate:, usd_amount:, brl_amount:)
    @dollar_rate = dollar_rate
    @available_cash = {
      'usd' => USD.new(amount: usd_amount, dollar_rate: dollar_rate),
      'brl' => BRL.new(amount: brl_amount, dollar_rate: dollar_rate)
    }
  end

  def buy(money)
    return "#{money.cost.description} insuficiente para essa operação" unless can_buy?(money)

    puts "Custo da operação: #{money.cost.symbol} #{money.cost.amount}"
    return 'Operação cancelada' unless confirm?('Deseja realizar a transação?')

    available_cash[money.cost.name].amount -= money.cost.amount
    available_cash[money.name].amount += money.amount
    transaction = create_transaction('Compra', money)
    transaction.save
    transaction.message
  end

  def sell(money)
    return "#{money.description} insuficiente para essa operação" unless can_sell?(money)

    puts "Rendimento da operação: #{money.cost.symbol} #{money.cost.amount}"
    return 'Operação cancelada' unless confirm?('Deseja realizar a transação?')

    available_cash[money.name].amount -= money.amount
    available_cash[money.cost.name].amount += money.cost.amount
    transaction = create_transaction('Venda', money)
    transaction.save
    transaction.message
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

  def list_all_transactions
    db = SQLite3::Database.open 'cambio.db'
    sql_select = "select "
    sql_select << "id, operation, amount, currency, dollar_rate, total "
    sql_select << "from transactions;"    
    tables = [] 
    select_result = db.execute(sql_select) 
    select_result.each do |row|
      result = []
      result << ['Tipo:', row[1]]
      result << ['Quantia:', row[2]]
      result << ['Moeda:', row[3]]
      result << ['Cotação:', row[4]]
      result << ['Total:', "U$#{row[5]}"]
      tables << (Terminal::Table.new :title => "Transação nº #{row[0]}", :rows => result)
    end
    tables
  end

  private

  def create_transaction(operation, money)
    transaction = Transaction.new(
      operation: operation,
      money: money,
      dollar_rate: dollar_rate
    )
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
