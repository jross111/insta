class User < ApplicationRecord
  has_secure_password
  has_many :pictures
  has_many :comments
  validates :username, presence: true { message: "Must have name" }
  validates :password, presence: true
  validates :email, inclusion: {in: ['@']}

  def received_comments
    user_pictures = @user.picture.map do |picture|
      picture.comments
    end

  end

end
