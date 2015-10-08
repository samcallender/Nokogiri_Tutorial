require 'HTTParty'
require 'Nokogiri'
require 'Pry'
require 'csv'

# this is how we request the page we're going to scrape
page = HTTParty.get('https://newyork.craigslist.org/search/pet')

# this is where we transform our http response into a nokogiri object so that we can parse it
parse_page = Nokogiri::HTML(page)

# this is an empty array where we will store all the craigslist pets listing for NYC
pets_array = []

# This is where we count the number of pages of pets listings
page_count = parse_page.css('.totalcount').text.to_i / 1000000


i = 0
while i <= page_count do
	page = HTTParty.get('https://newyork.craigslist.org/search/pet'+'?s='+page_count.to_s+'00')

	parse_page = Nokogiri::HTML(page)

	parse_page.css('.content').css('.row').css('.hdrlnk').map do |a|
		post_name = a.text
		pets_array.push(post_name)
	end
	
	i += 1
end

# this will push your array into a CSV file
CSV.open('pets.csv', 'w') do |csv|
	csv << pets_array
end

# Pry.start(binding)


