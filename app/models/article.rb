class Article < ActiveRecord::Base
  has_many :comments
  has_many :taggings
  has_many :tags, :through => :taggings
  has_many :vote

  belongs_to :user

  def tag_list
    # self.tags.collect do |t|
    #   t.name
    # end.join(", ")

    # Note: I defined a to_s inside tag.rb
    self.tags.collect.join(", ")
  end

  def tag_list=(tags_string)
    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq

    new_or_found_tags = tag_names.collect do |name| 
      Tag.find(:first, :conditions => {:name => name})
    end

    self.tags = new_or_found_tags
  end
end
