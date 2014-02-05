require 'watir-webdriver'
require 'nokogiri'
require 'json'
require 'pry'

# notf = 'GAJ4KBDCNAC GAJ4KBDCIDC GAJ4KBDCJCC GAJ4KBDCKAC GAJ4KBDCICC'
# best = 'GAJ4KBDCNAC GAJ4KBDCJCC GAJ4KBDCKAC GAJ4KBDCHDC GAJ4KBDCICC'
# second_b = 'GAJ4KBDCNAC GAJ4KBDCJCC GAJ4KBDCKAC GAJ4KBDCICC GAJ4KBDCCCC'
# alt = 'GAJ4KBDCNAC GAJ4KBDCJCC GAJ4KBDCKAC GAJ4KBDCICC'

# by_parent = 'doc.css('div.GAJ4KBDCMEC>div.gwt-HTML').children.length'

def scrape_flight_info(b)
	doc = Nokogiri::HTML.parse(b.html)

	flight_options = []
	flights = doc.css('div.GAJ4KBDCMEC>div.gwt-HTML>div>a')

	if flights.length == 0 then
		return false, false
	end

	flights.each do |flight|
		price = flight.css('div.GAJ4KBDCECC div[elt=p] div.GAJ4KBDCDCC').text[1..-1]
		timing = flight.css('div.GAJ4KBDCGDC div.GAJ4KBDCFDC span')
		departure_time = timing[0].children.first.text
		arrival_time = timing[1].children.first.text
		airline = flight.css('div.GAJ4KBDCGDC div.GAJ4KBDCBAC').children.first.text
		stops = flight.css('div.GAJ4KBDCPCC').children.first.children.text.strip
		flight_options << [price, departure_time, arrival_time, airline, stops]
	end

	best_flight_link = flights.first['href']
	return flight_options, best_flight_link
end

b = Watir::Browser.new :chrome


origin = 'SFO'
destinations = 'LAX, LAS, DEN, NEW, JFK, EWR, LGA, MSA, MIA, TMB, TNT, ORD, RFD, MDW, POR, RAL, JAX, OGG, LUP, MUE, MCI, TYS, CNY, MVY, MLB, ACK, SYR, BOS, PSM, TUL, YVR, YLW, CUN, SAP, GUA, SJO, MIA, SJU, SDQ, SFB, MCO, AUS, PHX, AZA, SLC, BOI, MSP, CLT, CHS, STL'.split(',').map!(&:strip)
dates = [['2014-03-05', '2014-03-08'], ['2014-03-07', '2014-03-09'], ['2014-03-07', '2014-03-10']]

results = []

dates.each do |date_pair|
	destinations.each do |destination|
		departure_date = date_pair[0]
		return_date = date_pair[1]

		filename_prefix = "#{origin}_#{destination}_#{departure_date}_#{return_date}"

		url = "http://www.google.com/flights/#search;f=#{origin};t=#{destination};d=#{departure_date};r=#{return_date}"
		b.goto url

		sleep(5)

		departure_flight_options, best_flight_link = scrape_flight_info(b)

		if departure_flight_options == false then
			results << [origin, destination, departure_date, return_date, 'No options.']
			puts 'No options.'
			File.open("#{filename_prefix}_dep.json","w") do |f|
			  f.write('No options.')
			end
			File.open("#{filename_prefix}_ret.json","w") do |f|
			  f.write('No options.')
			end
		else
			b.goto best_flight_link

			sleep(5)

			return_flight_options, best_flight_link = scrape_flight_info(b)

			best_dep_flight = departure_flight_options[0]
			best_ret_flight = return_flight_options[0]
			puts "Done"
			puts "Number of depart flight options: #{departure_flight_options.length}"
			puts "Best dep flight info: Price: #{best_dep_flight[0]}, Dep time: #{best_dep_flight[1]}, Arr time: #{best_dep_flight[2]}, Airline: #{best_dep_flight[3]}, Stops: #{best_dep_flight[4]}"
			puts "Number of return flight options: #{return_flight_options.length}"
			puts "Best ret flight info: Price: #{best_ret_flight[0]}, Dep time: #{best_ret_flight[1]}, Arr time: #{best_ret_flight[2]}, Airline: #{best_ret_flight[3]}, Stops: #{best_ret_flight[4]}"

			results << [origin, destination, departure_date, return_date, departure_flight_options, return_flight_options]

			File.open("#{filename_prefix}_dep.json","w") do |f|
			  f.write(departure_flight_options.to_json)
			end
			File.open("#{filename_prefix}_ret.json","w") do |f|
			  f.write(return_flight_options.to_json)
			end
		end
	end
end

File.open("results.json","w") do |f|
  f.write(results.to_json)
end

binding.pry

b.close

