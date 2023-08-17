# frozen_string_literal: true

class User < ApplicationRecord
  after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i[facebook]

  has_one_attached :avatar do |attachable|
    attachable.variant :preview, resize_to_limit: [500, 500]
    attachable.variant :circle, resize_to_limit: [50, 50]
  end
  has_many :friend_requests, ->(user) { where(friend_id: user.id, accepted: false) }, foreign_key: :friend_id
  has_many :sent_requests, class_name: 'FriendRequest'
  has_many :posts

  def friends
    friend_requests = FriendRequest.where(accepted: true).where('user_id = ? or friend_id = ?', id, id)
    friend_requests.map { |request| request.friend.id == id ? request.user : request.friend }
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.from_omniauth(auth)
    find_or_create_by(provider: auth.provider, uid: auth.uid)  do |user|
      user.email = auth.info.email
      user.provider = auth.provider
      user.uid = auth.uid
      user.password = Devise.friendly_token[0, 20]
    end
  end

  def send_welcome_email
    UserMailer.with(user_id: id).welcome_email.deliver_now
  end
end
