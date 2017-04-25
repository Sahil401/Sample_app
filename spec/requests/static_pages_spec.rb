require 'spec_helper'

describe "StaticPages" do
  describe "Home page" do
   it "should have content 'Sample App'" do
     visit '/static_pages/home/'
     expect(page).to have_content('Sample App')
   end
   it "Should have title 'Home'" do
   	visit('/static_pages/home/')
   	expect(page).not_to have_title('| Home')
   end
   end
   describe "Help page" do
   	it "should have content 'Help'"do
   	visit '/static_pages/help/'
   	expect(page).to have_content('Help')
   end
   it "Should have title 'Help'" do
   	visit('/static_pages/help/')
   	expect(page).to have_title('Ruby on Rails tutorial App | Help')
   end
   end
   describe "About page" do
   	it "should have content 'About Us'"do
     visit('/static_pages/about/')
     expect(page).to have_content('About Us')
   end
   it "Should have title 'About'" do
   	visit('/static_pages/about/')
   	expect(page).to have_title('Ruby on Rails tutorial App | About')
   end
	end
end
