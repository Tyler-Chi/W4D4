# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  user_name       :string           not null
#  password_digest :string           not null
#  session_token   :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

class User < ApplicationRecord
  validates :user_name, presence: true, uniqueness: true
  validates :password_digest, presence: true
  validates :password, length: { minimum: 6, allow_nil: true }

  validates :session_token, presence: true, uniqueness: true

  attr_reader :password

  after_initialize :ensure_session_token



  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64
    self.save
    self.session_token
  end

  def password=(pw)
    @password = pw
    self.password_digest = BCrypt::Password.create(pw)

    #when this is saved, because in the migration, it is t.string, so the BCrypt object
    #is automagically typecasted into a string. thats why later in the is_password?(pw)
    #we have to convert BACK into the bcrypt object, in order to use the is_password? method.
  end

  def is_password?(pw)
    pass_hash = BCrypt::Password.new(self.password_digest)
    pass_hash.is_password?(pw)
  end

  def self.find_by_credentials(username, pw)
    user = User.find_by(user_name: username)
    return nil if user.nil?
    user.is_password?(pw) ? user : nil
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64
  end


end
