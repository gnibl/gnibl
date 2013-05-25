require 'spec_helper'
include Capybara::DSL

describe "Static pages" do
  

	
  describe "Help page" do
  it " should return 'help'" do
  visit '/static_pages/help'
page.should have_selector('title', :text => "Gnibl")
  end
  end

 describe "Contact Page" do
 it "should have the word contact in h1" do
  visit("/static_pages/about")
  page.should have_selector("h1","contact") 
 end
 
 it "should have contact in title" do
 visit("/static_pages/about")
 page.should have_selector("title","contact")
 end
 end


  describe "About page" do

     it "should have about page" do
        visit '/static_pages/about'
        page.should have_selector('title', :text => "Gnibl")
     end     
   
    it "should have about page" do
        visit '/static_pages/about'
        page.should have_selector('title', :text => "Gnibl")
     end     
   end
  
end
