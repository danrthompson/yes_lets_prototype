require 'watir-webdriver'
require 'nokogiri'
require 'pry'

def scrape_flight_info(doc)
	flight_options = []
	flights = doc.css('div.GAJ4KBDCNAC.GAJ4KBDCJCC.GAJ4KBDCKAC.GAJ4KBDCICC')

	flights.each do |flight|
		price = flight.css('a div.GAJ4KBDCECC div[elt=p] div.GAJ4KBDCDCC').text[1..-1]
		timing = flight.css('a div.GAJ4KBDCGDC div.GAJ4KBDCFDC span')
		departure_time = timing[0].children.first.text
		arrival_time = timing[1].children.first.text
		airline = flight.css('a div.GAJ4KBDCGDC div.GAJ4KBDCBAC').children.first.text
		stops = flight.css('a div.GAJ4KBDCPCC').children.first.children.text.strip
		flight_options << [price, departure_time, arrival_time, airline, stops]
	end
	flight_options
end

b = Watir::Browser.new :chrome


origin = 'SFO'
destination = 'NYC'
departure_date = '2014-02-19'
return_date = '2014-02-23'

url = "http://www.google.com/flights/#search;f=#{origin};t=#{destination};d=#{departure_date};r=#{return_date}"

b.goto url

sleep(5)

doc = Nokogiri::HTML.parse(b.html)

departure_flight_options = scrape_flight_info(doc)

b.goto doc.css('div.GAJ4KBDCNAC.GAJ4KBDCJCC.GAJ4KBDCKAC.GAJ4KBDCICC').first.css('a').first['href']

sleep(5)

doc = Nokogiri::HTML.parse(b.html)

return_flight_options = scrape_flight_info(doc)

best_dep_flight = departure_flight_options[0]
best_ret_flight = return_flight_options[0]
puts "Done"
puts "Number of depart flight options: #{departure_flight_options.length}"
puts "Best dep flight info: Price: #{best_dep_flight[0]}, Dep time: #{best_dep_flight[1]}, Arr time: #{best_dep_flight[2]}, Airline: #{best_dep_flight[3]}, Stops: #{best_dep_flight[4]}"
puts "Number of return flight options: #{return_flight_options.length}"
puts "Best ret flight info: Price: #{best_ret_flight[0]}, Dep time: #{best_ret_flight[1]}, Arr time: #{best_ret_flight[2]}, Airline: #{best_ret_flight[3]}, Stops: #{best_ret_flight[4]}"

b.close

