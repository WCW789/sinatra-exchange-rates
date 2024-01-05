require "sinatra"
require "sinatra/reloader"
require "http"
require "json"

def exchange_rate_program
  api_url_list = "http://api.exchangerate.host/list?access_key=#{ENV.fetch("EXCHANGE_RATES_KEY")}"
  exchange_rates_data = HTTP.get(api_url_list)
  parsed_exchange_rates_data = JSON.parse(exchange_rates_data)
  currencies_data = parsed_exchange_rates_data.fetch("currencies")
end

get("/") do
  @currencies_keys = exchange_rate_program.keys

  erb(:homepage)
end

get("/:name_of_currency") do
  @currencies_keys = exchange_rate_program.keys
  @name_of_currency = params.fetch("name_of_currency")

  erb(:convert)
end

get("/:name_of_currency/:comp") do
  @currencies_keys = exchange_rate_program.keys
  @name_of_currency = params.fetch("name_of_currency")
  @comp = params.fetch("comp")

  api_url_convert = "http://api.exchangerate.host/convert?access_key=#{ENV.fetch("EXCHANGE_RATES_KEY")}&from=#{@name_of_currency}&to=#{@comp}& amount=1"
  exchange_rates_convert = HTTP.get(api_url_convert)
  parsed_exchange_rates_convert = JSON.parse(exchange_rates_convert)
  @comp_convert = parsed_exchange_rates_convert.fetch("result")

  erb(:comp)
end
