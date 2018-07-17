#A simple web server for comparing currency changes on a daily basis

require 'net/http'
require 'json'
require 'mail'
require 'rubygems'
require 'sqlite3'
require 'gchart'
require_relative 'lib/email'
require_relative 'lib/currencycompare'
require_relative 'lib/history'
require_relative 'lib/frontend'
require_relative 'lib/charts'

config = YAML.load_file('data/config.yml')

Frontend.new.init(config)

array = config["ARRAY"]
emailarray = []

url = config["API_URL"]
uri = URI(url)

responsecheck = Net::HTTP.get_response(uri)

case responsecheck.code.to_i
when 200 || 201
  response = Net::HTTP.get(uri)
  curr_api  = JSON.parse(response)
when [400..499]
  abort("Bad request error. Try again later.")
when [500..599]
  abort("Server problems. Try again later.")
end

if File.empty?('data/valute.json') == true
  Email.new.firstemail(array)
  File.write("data/valute.json", curr_api.to_json)
  History.new.save(curr_api)
  abort("Initialization complete.")
end

curr_file = JSON.parse(File.read("data/valute.json"))

if curr_api[0]["Datum primjene"] == curr_file[0]["Datum primjene"]
  abort('The currency values have not changed yet. Try again later.')
end

array.each{ |chosencurrency|
    curr_file.each{ |oldvalue|
      oldvalue["Srednji za devize"].sub! ",", "."
      curr_api.each { |newvalue|
        newvalue["Srednji za devize"].sub! ",", "."
        if newvalue["Valuta"] == chosencurrency && newvalue["Valuta"] == oldvalue["Valuta"]
          Currency.new.compare(newvalue["Srednji za devize"].to_f, oldvalue["Srednji za devize"].to_f, chosencurrency, emailarray)
        end
      }
    }
  }

  if emailarray.empty? == false
    urlchart = Charts.new.create
    Email.new.standardemail(emailarray, urlchart)
  end

File.write("data/valute.json", curr_api.to_json)

History.new.save(curr_api)
