require 'HTTParty'
require 'Nokogiri'
require 'Pry'
require 'csv'

# this is how we request the page we're going to scrape
page = HTTParty.get('https://newyork.craigslist.org/search/pet?s=0')

# this is where we transform our http response into a nokogiri object so that we can parse it
parse_page = Nokogiri::HTML(page)

# this is an empty array where we will store all the craigslist pets listing for NYC
pets_array = []

# this is where we parse the data
parse_page.css('.content').css('.row').css('.hdrlnk').map do |a|
	post_name = a.text
	pets_array.push(post_name)
end

# this will push your array into a CSV file
CSV.open('pets.csv', 'w') do |csv|
	csv << pets_array
end

# Pry.start(binding)