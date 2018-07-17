class Currency
  def compare(newvalue, oldvalue, currencyname, fivepercenter)
    puts "#{newvalue} nova vrijednost valute"
    if newvalue/oldvalue >= 1.05 || newvalue/oldvalue <= 0.95
      puts "promjena veća od 5%"
      fivepercenter << currencyname
    else
      puts "promjena manja od 5%"
    end
  end
end
