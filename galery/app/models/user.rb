class User < ActiveRecord::Base
    validates :name, presence: true
    validates :email, presence: true
    has_secure_password

    has_many :galeries
    has_many :friends
  

    def self.find_by_slug(slug)
      self.all.find{ |user| user.slug == slug }
    end
    def slug
      self.pseudo.gsub(" ", "-").downcase
    end

    def friend_check(id)
      self.friends.where(friend_id: id).first
    end
  
  end