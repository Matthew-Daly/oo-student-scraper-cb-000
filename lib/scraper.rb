require 'nokogiri'
require 'open-uri'
require 'pry'

class Scraper

  def self.scrape_index_page(index_url)
  	html = File.read('fixtures/student-site/index.html')
  	doc = Nokogiri::HTML(html)
    
  	students_array = []

    doc.css(".student-card a").each do |profile|
	    name = profile.css("h4").text
	    location = profile.css("p").text
	    url = "./fixtures/student-site/#{profile.attribute('href')}"
	    students_array << { name: name, location: location, profile_url: url}
	end
	students_array
	
  end

  def self.scrape_profile_page(profile_url)
  	student = {}

  	html = File.read(profile_url)
  	doc = Nokogiri::HTML(html)

  	doc.css(".vitals-container").each do |attr|
  		attr.css(".social-icon-container a").each do |link|
  			
  			if (link.attribute('href').value.include?("linkedin"))
  				student[:linkedin] = link.attribute('href').value
  			elsif (link.attribute('href').value.include?("github"))
  				student[:github] = link.attribute('href').value
  		    elsif (link.attribute('href').value.include?("twitter"))
  				student[:twitter] = link.attribute('href').value
  			else 
  				student[:blog] = link.attribute('href').value
  			end
  		end

  		student[:profile_quote] = attr.css(".profile-quote").text
  		student[:bio] = doc.css(".description-holder p").text
  		
    end
    student
  end

end

