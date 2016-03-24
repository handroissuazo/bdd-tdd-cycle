def log(s)
  puts "[Debug]: #{s}"
end

Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    Movie.create!(movie)
  end
end

Then /the director of "Star Wars" should be "(.*)"/ do |updated_director|
  pos = page.body.index(updated_director)
  if pos < 0
    fails "Failed updating director"
  end
end

And /I am supposed to see "'Star Wars' has no director info"/ do
  regexp = Regexp.new("Star Wars PG 1977-5-25")

  if page.respond_to? :should
    page.should have_xpath('//*', :text => regexp)
  else
    assert page.has_xpath?('//*', :text => regexp)
  end
end
