require_relative 'cashier'
require_relative 'usd'
require_relative 'brl'

def start_cashier
  print 'Informe a cotação do Dólar de hoje: '
  dollar_rate = gets.to_f
  print 'Informe o valor de Dólares disponível (USD) U$: '
  usd_amount = gets.to_f
  print 'Informe o valor de Reais disponível (BRL) R$: '
  brl_amount = gets.to_f
  Cashier.new(
    dollar_rate: dollar_rate,
    usd_amount: usd_amount,
    brl_amount: brl_amount
  )
end

cashier = start_cashier

BUY_DOLLAR  = 1
SELL_DOLLAR = 2
BUY_REAL    = 3
SELL_REAL   = 4
LIST_TRANSACTIONS = 5
CASHIER_SUMMARY   = 6
EXIT_APP = 7

def menu
  puts "\n--- CASA DE CAMBIO ---\n\n"
  puts '[1] Comprar dólares'
  puts '[2] Vender dólares'
  puts '[3] Comprar reais'
  puts '[4] Vender reais'
  puts '[5] Ver operações do dia'
  puts '[6] Ver situação do caixa'
  puts "[7] Sair\n"
  puts "\nInforme a opção desejada: "
  gets.to_i
end

option = 0
loop do
  option = menu
  case option
  when BUY_DOLLAR
    print 'Quanto em Dólares deseja comprar? '
    buying = USD.new(amount: gets.to_f, dollar_rate: cashier.dollar_rate)
    puts cashier.buy(buying)
  when SELL_DOLLAR
    print 'Quanto em Dólares deseja vender? '
    selling = USD.new(amount: gets.to_f, dollar_rate: cashier.dollar_rate)
    puts cashier.sell(selling)
  when BUY_REAL
    print 'Quanto em Reais deseja comprar? '
    buying = BRL.new(amount: gets.to_f, dollar_rate: cashier.dollar_rate)
    cashier.buy(buying)
  when SELL_REAL
    print 'Quanto em Reais deseja vender? '
    selling = BRL.new(amount: gets.to_f, dollar_rate: cashier.dollar_rate)
    puts cashier.sell(selling)
  when LIST_TRANSACTIONS
    cashier.transactions.each { |transaction| puts transaction.to_s }
  when CASHIER_SUMMARY
    puts cashier.summary
  when EXIT_APP
    break
  else
    puts 'Opção inválida!'
  end
  option = 0

  break unless option <= 0 || option > 7
end
