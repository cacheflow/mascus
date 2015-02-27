require "mechanize"
agent = Mechanize.new 

page = agent.get("http://www.mascus.com/john+deere/categorypath%3dagriculture/countrycode%3dus%26region%3dillinois/1,100,relevance,search.html")
first_page = page.at("div.pager_pages").children.first.text 
last_page =  page.at("div.pager_pages").children.last.text

while i < last_page 
  if first_page == last_page 
    next_page = false 
  else 
    agent = Mechanize.new 
    agent.user_agent = "Chrome"
    mech = agent.get("http://www.mascus.com/john+deere/categorypath%3dconstruction/+/1,100,relevance,search.html")
    mech.search("td.column2 > a").each do |links| 
    mech_get_links = agent.get("http://www.mascus.com#{links.attributes['href']}")
    if mech_get_links.at("span#phone-number-button") && mech_get_links.search("//span[@itemprop='price']", "//span[@itemprop='brand']", "//span[@itemprop='description']", "tr.row4 > td.cell1")
      if doc.at("//span[@itemprop='price']") 
        price = doc.at("//span[@itemprop='price']").text 
          if doc.at("tr.row4 > td.cell1")
            location = doc.at("tr.row4 > td.cell1").text
             if doc.at("//span[@itemprop='brand']") 
              brand = doc.at("//span[@itemprop='brand']").text
                if doc.at("//span[@itemprop='description']")
                  description = doc.at("//span[@itemprop='description']").text   
                  puts description 
                  puts price
                  agent.current_page
                end 
              end 
          end 
        end 
      end 
    end 
  end 