Given /^I access the url "(.*?)"$/ do |url|
  visit url
end

Then /^I see "(.*?)"$/ do |content|
  page.should have_content(content)
end

When /^I click on the elem "(.*?)"$/ do |elem_name|
    click_on elem_name
end

Then /^The url address is equal to "(.*?)"$/ do |url|
    current_url.split("/#/")[1].should == "tab1"
end

Then /^I do not see "(.*?)"$/ do |content|
  page.should_not have_content(content)
end

When /^I click history back button$/ do
   page.evaluate_script('window.history.back()')
end
