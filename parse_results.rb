require 'json'
require 'pry'

dates = [['2014-02-05', '2014-02-08'], ['2014-02-05', '2014-02-09'], ['2014-02-07', '2014-02-09'], ['2014-02-07', '2014-02-10']]

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
min_price_flights_date4 = []

min_price_flights.each do |flight|
	if flight[2] == dates[0][0] and flight[3] == dates[0][1] then
		min_price_flights_date1 << flight
	elsif flight[2] == dates[1][0] and flight[3] == dates[1][1] then
		min_price_flights_date2 << flight
	elsif flight[2] == dates[2][0] and flight[3] == dates[2][1] then
		min_price_flights_date3 << flight
	elsif flight[2] == dates[3][0] and flight[3] == dates[3][1] then
		min_price_flights_date4 << flight
	end
end

min_price_flights_all.sort! {|a,b| a[4] <=> b[4]}
min_price_flights_date1.sort! {|a,b| a[4] <=> b[4]}
min_price_flights_date2.sort! {|a,b| a[4] <=> b[4]}
min_price_flights_date3.sort! {|a,b| a[4] <=> b[4]}
min_price_flights_date4.sort! {|a,b| a[4] <=> b[4]}

File.open('parsed_results.txt', 'w') do |f|
	f.puts 'Cheapest options among all dates:'
	(0..14).each do |i|
		f.puts "#{i + 1}: #{min_price_flights_all[i]}"
	end
	f.puts "Cheapest options leaving on #{dates[0][0]} and returning on #{dates[0][1]}:"
	(0..14).each do |i|
		f.puts "#{i + 1}: #{min_price_flights_date1[i]}"
	end
	f.puts "Cheapest options leaving on #{dates[1][0]} and returning on #{dates[1][1]}:"
	(0..14).each do |i|
		f.puts "#{i + 1}: #{min_price_flights_date2[i]}"
	end
	f.puts "Cheapest options leaving on #{dates[2][0]} and returning on #{dates[2][1]}:"
	(0..14).each do |i|
		f.puts "#{i + 1}: #{min_price_flights_date3[i]}"
	end
	f.puts "Cheapest options leaving on #{dates[3][0]} and returning on #{dates[3][1]}:"
	(0..14).each do |i|
		f.puts "#{i + 1}: #{min_price_flights_date4[i]}"
	end
end

binding.pry