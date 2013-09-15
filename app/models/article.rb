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
    # split tags
    tag_names = tags_string.split(",").collect{|s| s.strip.downcase}.uniq
    
    # create new tags
    article_tags = []
    tag_names.each do |tag|
      atag = Tag.find(:first, :conditions => {:name => tag})
      if atag.nil? then
        atag = Tag.new(:name => tag)
        atag.save
      end
      article_tags << atag
    end

    # add tags to article
    # self.tags.create if not self.tags
    self.tags = article_tags if article_tags
    
    save

    # remove empty tags
    Tag.all.each do |tag|
      Tag.destroy tag if tag.articles.empty?
    end
  end
end
