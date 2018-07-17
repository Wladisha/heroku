
class History
  def save (api)
    db = SQLite3::Database.new('data\history.sqlite')

    api.each{ |info|
      db.execute('INSERT INTO valute (Broj_tecajnice, Datum_primjene, Drzava, Sifra_valute, Valuta, Jedinica, Kupovni_za_devize, Srednji_za_devize, Prodajni_za_devize) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', [info["Broj tečajnice"], info["Datum primjene"], info["Država"], info["Šifra valute"], info["Valuta"], info["Jedinica"], info["Kupovni za devize"], info["Srednji za devize"], info["Prodajni za devize"]])
    }
  end

  def populate
    config = YAML.load_file('data/config.yml')
    db = SQLite3::Database.new('data\history.sqlite')
    db.results_as_hash = true
    datecheck = db.execute('SELECT * FROM valute')

    datestring = Date.strptime(datecheck.last["Datum_primjene"], '%d.%m.%Y').strftime('%Y-%m-%d')
    date = Date.strptime(datestring, '%Y-%m-%d')

    if date == Date.today
      abort ("History is already up to date")
    elseif date < (Date.today-30)
       url = "#{config["API_URL"]}?datum-od=#{Date.today - 30}&datum-do=#{Date.today}"
    else
       url = "#{config["API_URL"]}?datum-od=#{date + 1}&datum-do=#{Date.today}"
    end

    uri = URI(url)
    response = Net::HTTP.get(uri)
    range_api  = JSON.parse(response)

    range_api.each{ |info|
      db.execute('INSERT INTO valute (Broj_tecajnice, Datum_primjene, Drzava, Sifra_valute, Valuta, Jedinica, Kupovni_za_devize, Srednji_za_devize, Prodajni_za_devize) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)', [info["Broj tečajnice"], info["Datum primjene"], info["Država"], info["Šifra valute"], info["Valuta"], info["Jedinica"], info["Kupovni za devize"], info["Srednji za devize"], info["Prodajni za devize"]])
    }

  end

  def print (currency) #print history for chosen currencies
    db = SQLite3::Database.new('data\history.sqlite')
    print = db.execute('SELECT * FROM valute')
    print.each {|row|
      currency.each{ |value|
        if value == row[4]
        puts row.join(', ')
      end
      }
    }
  end

end
