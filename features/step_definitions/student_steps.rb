Then /^I add the following siblings$/ do |table|
  # table is a Cucumber::Ast::Table
  siblings = table.raw.flatten.join("\n")
  And %Q{I fill in "Siblings" with "#{siblings}"}
end

Then /^I should see the student "([^\"]*)" with$/ do |name, table|
  page.should have_css(".name:contains('#{name}')")
  output = []
  table.raw.each do |key, value|
    output << [key, find("#person .#{key.parameterize}").try(:text)]
  end
  table.diff!(output)
end

Then /^I should see the following siblings$/ do |table|
  # table is a Cucumber::Ast::Table
  page.has_css?('#person .siblings').should == true
  within('#person .siblings .sibling') do
    table.raw.each { |row| page.should have_content(row[0]) }
  end
end

Then /^I should see the student "([^\"]*)"$/ do |name|
  within('.people .person') do
    page.should have_content(name)
    page.should have_css('img')
  end
end

def find_css_text(selector)
  find(selector).try(:text)
end

def find_student_details_in_student_list(keys)
  actual = []
  actual << keys.inject({}) do |student_details, key|
    student_details[key] = find_css_text(".students .student .#{key.parameterize}")
    student_details
  end
end

Given /^a student called "([^\"]*)"$/ do |name|
  person = Factory.create :person, :name => name
  person.make_student!
end

Given /^a student called "([^\"]*)" in (village "[^\"]*")$/ do |student_name, village|
  person = Factory.create :person, :name => student_name, :village => village
  person.make_student!
end

Transform /^village "([^\"]*)"$/ do |village_name|
  Village.find_by_name(village_name)
end

When /^I update the student with the following details$/ do |table|
  click_link('Edit')
  fill_in_fields(table)
  click_button('Update')
end
