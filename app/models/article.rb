class Article < ActiveRecord::Base
  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings

  def tag_list
    # self.tags.collect do |t|
    #   t.name
    # end.join(", ")

    # Note: I defined a to_s inside tag.rb
    self.tags.collect.join(", ")
  end

  def tag_list=(tags_string)
    tags_string.split(",").collect{|s| s.strip.downcase}.uniq
  end
end
