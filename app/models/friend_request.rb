# frozen_string_literal: true

class FriendRequest < ApplicationRecord
  belongs_to :user
  belongs_to :friend, class_name: 'User', foreign_key: 'friend_id'
end
