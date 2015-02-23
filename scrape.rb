require "mechanize"
require "nokogiri"
require "capybara"
require "capybara/dsl"
require "capybara-webkit"

include Capybara::DSL
Capybara.current_driver = :webkit
Capybara.run_server = false 
##right here we're including the Capybara DSL 
##so we can call many of the methods like visit, find, etc..
agent = Mechanize.new 
mech = agent.get("http://www.mascus.com/john+deere/+/+/1,100,relevance,search.html?us=categorypath%3Dagriculture")
links = []
mech.links.each do |link| 
  if link.text.start_with?("John Deere") && link.href.start_with?("/agriculture/") && !link.href.to_s.end_with?("modelgroup.html")
    page.visit("http://www.mascus.com#{link.href}")
      if page.has_css?("#phone-number-button")
        page.find("#phone-number-button").click
        doc = Nokogiri::HTML.parse(body)
        puts "THE NUMBER IS " + doc.css("#phone-number-button").text 
        mechanize_parse = agent.get("#{link.href}")
      end           
  end 
end 

