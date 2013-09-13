Article.create(:title => "First Story", :body => "Hello world!")

str = "."
512.times do |j|
  str = str + "#{j}"
  str = str + "\n" if j % 10 == 0
end

10.times do |i|
  Article.create(:title => "Sample #{i}", :abstract => "Abstract #{i} #{i.to_s * i * 10}", :body => str)
end
