require 'spec_helper'
include Capybara::DSL

describe "Static pages" do
  

	
  describe "Help page" do
  it " should return 'help'" do
  visit '/static_pages/help'
page.should have_selector('title', :text => "Gnibl")
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
