class User < ActiveRecord::Base
  has_many :tweets
  has_secure_password
  validates_presence_of :username, :email, :password

  def slug
    self.username.gsub(" ","-").downcase
  end

  def self.find_by_slug(slug)
    all.each do |x|
      return x if x.slug == slug
    end
  end

end
