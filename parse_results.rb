require 'json'
require 'pry'

results = nil
File.open('results.json', 'r') do |f|
	results = JSON.load(f)
end

min_price_flights = []

results.each do |option|
	if option[4] != 'No options.' then
		temp = option[0..3]
		min_price = 10000
		min_flight = nil
		option[4].each do |flight|
			if not flight[0].nil? then
				price = flight[0].gsub(',','').to_i
				if price < min_price then
					min_price = price
					min_flight = flight
				end
			end
		end
		temp << min_price
		min_price_flights << temp
	end
end

min_price_flights_all = min_price_flights
min_price_flights_date1 = []
min_price_flights_date2 = []
min_price_flights_date3 = []

min_price_flights.each do |flight|
	if flight[2] == '2014-03-05' and flight[3] == '2014-03-08' then
		min_price_flights_date1 << flight
	elsif flight[2] == '2014-03-07' and flight[3] == '2014-03-09' then
		min_price_flights_date2 << flight
	elsif flight[2] == '2014-03-07' and flight[3] == '2014-03-10' then
		min_price_flights_date3 << flight
	end
end

min_price_flights_all.sort! {|a,b| a[4] <=> b[4]}
min_price_flights_date1.sort! {|a,b| a[4] <=> b[4]}
min_price_flights_date2.sort! {|a,b| a[4] <=> b[4]}
min_price_flights_date3.sort! {|a,b| a[4] <=> b[4]}

File.open('parsed_results.txt', 'w') do |f|
	f.puts 'Cheapest options among all dates:'
	(0..14).each do |i|
		f.puts "#{i + 1}: #{min_price_flights_all[i]}"
	end
	f.puts 'Cheapest options leaving on 2014-03-05 and returning on 2014-03-08:'
	(0..14).each do |i|
		f.puts "#{i + 1}: #{min_price_flights_date1[i]}"
	end
	f.puts 'Cheapest options leaving on 2014-03-07 and returning on 2014-03-09:'
	(0..14).each do |i|
		f.puts "#{i + 1}: #{min_price_flights_date2[i]}"
	end
	f.puts 'Cheapest options leaving on 2014-03-07 and returning on 2014-03-10:'
	(0..14).each do |i|
		f.puts "#{i + 1}: #{min_price_flights_date3[i]}"
	end
end

binding.pry