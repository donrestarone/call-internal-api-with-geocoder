require 'httparty'
require 'geocoder'

puts 'start address'
start_addr = STDIN.gets.chomp
puts 'end address'
end_addr = STDIN.gets.chomp
p "getting data for #{Geocoder.address(start_addr)} and #{Geocoder.address(end_addr)}"
start_lat = (Geocoder.coordinates(start_addr))[0]
start_lon = (Geocoder.coordinates(start_addr))[1]
end_lat = (Geocoder.coordinates(end_addr))[0]
end_lon = (Geocoder.coordinates(end_addr))[1]


url = "http://taxi-fare-api.herokuapp.com/price/show.json?sl=#{start_lat}&slon=#{start_lon}&&el=#{end_lat}&&elon=#{end_lon}"
body = JSON.parse(HTTParty.get(url).body)

uber_prices = []
lyft_prices = []
body["uber"].each do |uber_fare|
	uber_prices.push(uber_fare["fare"])
	body["lyft"].each do |lyft_fare|
		lyft_prices.push(lyft_fare["fare"])
	end
end

cheapest_uber = uber_prices.sort[0]
cheapest_lyft = lyft_prices.sort[0]

body["uber"].each do |uber_fare|
	if uber_fare["fare"] == cheapest_uber
		p "***cheapest Uber fare for given trip is $#{uber_fare["type"]} costing #{cheapest_uber}***"
	end
end

body["lyft"].each do |lyft_fare|
	if lyft_fare["fare"] == cheapest_lyft
		p "***cheapest Lyft fare for given trip is $#{lyft_fare["type"]} costing #{cheapest_lyft}***"	
	end
end

p "#-------------------------------------------------#"

p "full price list breakdown"
body["uber"].each do |uber_fare|
	p "type: #{uber_fare["type"]}, response time: #{uber_fare["eta"] / 60} minutes, price: $#{uber_fare["fare"]}"
end

body["lyft"].each do |lyft_fare|
	p "type: #{lyft_fare["type"]}, response time: #{lyft_fare["eta"] / 60} minutes, price: $#{lyft_fare["fare"]}"
end