require_relative 'cash_register'
require_relative 'usd'
require_relative 'brl'

def start_cash_register
  print 'Informe a cotação do Dólar de hoje: '
  dollar_rate = gets.to_f
  print 'Informe o valor de Dólares disponível (USD) U$: '
  usd_amount = gets.to_f
  print 'Informe o valor de Reais disponível (BRL) R$: '
  brl_amount = gets.to_f
  CashRegister.new(
    dollar_rate: dollar_rate,
    usd_amount: usd_amount,
    brl_amount: brl_amount
  )
end

cash_register = start_cash_register

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
  when 1
    print 'Quanto em Dólares deseja comprar? '
    buying = USD.new(amount: gets.to_f, dollar_rate: cash_register.dollar_rate)
    puts cash_register.buy(buying)
  when 2
    print 'Quanto em Dólares deseja vender? '
    selling = USD.new(amount: gets.to_f, dollar_rate: cash_register.dollar_rate)
    cash_register.sell(selling)
  when 3
    print 'Quanto em Reais deseja comprar? '
    buying = BRL.new(amount: gets.to_f, dollar_rate: cash_register.dollar_rate)
    cash_register.buy(buying)
  when 4
    print 'Quanto em Reais deseja vender? '
    selling = BRL.new(amount: gets.to_f, dollar_rate: cash_register.dollar_rate)
    cash_register.sell(selling)
  when 5
    cash_register.transactions.each { |transaction| puts transaction.to_s }
  when 6
    puts cash_register.summary
  when 7
    break
  end
  option = 0

  break unless option <= 0 || option > 7
end
