require "mechanize"
require "csv"
require "nokogiri"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"

class Mascus 
	include Capybara::DSL
	Capybara.current_driver = :webkit
	Capybara.run_server = false 
	attr_reader :doc
	##right here we're including the Capybara DSL 
	##so we can call many of the methods like visit, find, etc..
	def scrape 
		agent = Mechanize.new 
		agent.user_agent = "Safari"
		mech = agent.get("http://www.mascus.com/john+deere/+/+/1,200,relevance,search.html?us=categorypath%3Dagriculture")
		mech.search("td.column2 > a").each do |links| 
			mech_get_links = agent.get("http://www.mascus.com#{links.attributes['href']}")
			if mech_get_links.at("span#phone-number-button") && mech_get_links.search("//span[@itemprop='price']", "//span[@itemprop='brand']", "//span[@itemprop='description']")
					visit("#{mech_get_links.uri}")	
					  # page.driver.allow_url("#{mech_get_links.uri}")
					  page.driver.allow_url("http://stats.g.doubleclick.net")
					  # page.driver.allow_url("http://www.mascus.com/images")
					  # page.driver.allow_url("http://static.mascus.com")
					  # page.driver.block_url("http://su.addthis.com")
					  # page.driver.block_url("http://dev.visualwebsiteoptimizer.com")
					  # page.driver.block_url("http://ib.adnxs.com")
					  # page.driver.block_unknown_urls

					first("#phone-number-button").click 
					doc = Nokogiri::HTML.parse(body)
					price = doc.at("//span[@itemprop='price']")
					if price 
						puts "THIS IS THE PRICE " + price.text 
					end 	
					brand = doc.at("//span[@itemprop='brand']")
					if brand 
						puts "THIS IS THE BRAND " + brand.text 
					end 	
					description = doc.at("//span[@itemprop='description']")
					if description
						puts "THIS IS THE TEXT " + description.text 
					end  
					image = doc.css(".image_main").first.attributes["src"].text
					if image 
						puts "THIS IS THE IMAGE " + image 
					end				
			end
		end 
	end
end 



mascus = Mascus.new 

mascus.scrape

# map(&:href).collect{|href| "http://www.mascus.com#{href}" }

  # if link.href.start_with?("/agriculture/") && !link.href.to_s.end_with?("modelgroup.html")
  # 	puts link.href 
    # visit("http://www.mascus.com#{link.href}")

    #     page.find("#phone-number-button").click
    #     doc = Nokogiri::HTML.parse(body)
    #     image = doc.css(".image_main").first.attributes["src"].text
    #     mech = agent.get("#{image}")
    #     mech.save           
#   end 
# end 

