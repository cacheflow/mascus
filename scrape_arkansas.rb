require "mechanize"
require "csv"
require "nokogiri"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"

class Arkansas 
	include Capybara::DSL
	Capybara.current_driver = :webkit
	Capybara.run_server = false 
	attr_reader :doc
	##right here we're including the Capybara DSL 
	##so we can call many of the methods like visit, find, etc..
	def scrape
		agent = Mechanize.new 
		agent.user_agent = "Chrome"
		mech = agent.get("http://www.mascus.com/john+deere/categorypath%3dagriculture/countrycode%3dus%26region%3darkansas/1,100,relevance,search.html")
		mech.search("td.column2 > a").each do |links| 
			mech_get_links = agent.get("http://www.mascus.com#{links.attributes['href']}")
			if mech_get_links.at("span#phone-number-button") && mech_get_links.search("//span[@itemprop='price']", "//span[@itemprop='brand']", "//span[@itemprop='description']", "tr.row4 > td.cell1")
				visit("#{mech_get_links.uri}")	
				  # page.driver.allow_url("#{mech_get_links.uri}")
				page.driver.allow_url("http://stats.g.doubleclick.net")
				  # page.driver.allow_url("http://www.mascus.com/images")
				  # page.driver.allow_url("http://static.mascus.com")
				  # page.driver.block_url("http://su.addthis.com")
				  # page.driver.block_url("http://dev.visualwebsiteoptimizer.com")
				  # page.driver.block_url("http://ib.adnxs.com")
				  # page.driver.block_unknown_urls
				headers = ["Brand", "Number", "Location", "Price", "Description", "ImageName"]  
				CSV.open("JohnDeereAdsInArkansas.csv", "a+") do |csv|  
					first("#phone-number-button").click 
					doc = Nokogiri::HTML.parse(body)
					headers = nil
					price = doc.at("//span[@itemprop='price']").text 	  
					location = doc.at("tr.row4 > td.cell1").text
					brand = doc.at("//span[@itemprop='brand']").text
					description = doc.at("//span[@itemprop='description']").text
					number = doc.css("#phone-number-button").text 
					image = doc.css(".image_main").first.attributes["src"].text
					csv << [brand, number, location, price, description, image]
				end 
			end
		end 
	end


end 



mascus_arkansas = Arkansas.new 

mascus_arkansas.scrape_again



