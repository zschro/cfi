When /^I add the photo "([^\"]*)" with comment "([^\"]*)"$/ do |file_name, comment|
  attach_file "photo_image", Rails.root.join('test', 'fixtures', file_name)
  fill_in "photo_comment", :with => comment
  click_button "Add"
end

Then /^I should see the photo "([^\"]*)" with comment "([^\"]*)"$/ do |file_name, comment|
  with_scope(".photo") do
    page.should have_css("img[src*='#{file_name}']")
    page.should have_css(".comment", comment)
  end
end