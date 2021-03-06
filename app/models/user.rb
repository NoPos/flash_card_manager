# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  email            :string
#  crypted_password :string
#  created_at       :datetime
#  updated_at       :datetime
#  salt             :string
#  current_deck_id  :integer
#
# Indexes
#
#  index_users_on_email  (email) UNIQUE
#

class User < ActiveRecord::Base
  authenticates_with_sorcery! do |config|
    config.authentications_class = Authentication
  end

  has_many :cards, dependent: :destroy
  has_many :decks, dependent: :destroy
  has_many :authentications, dependent: :destroy
  belongs_to :current_deck, class_name: 'Deck', foreign_key: :current_deck_id

  accepts_nested_attributes_for :authentications

  validates :password, presence: true, length: { minimum: 3 }
  validates :password, confirmation: true, unless: Proc.new { |a| a.password.blank? }
  validates :password_confirmation, presence: true, unless: Proc.new { |a| a.password.blank? }

  validates :email, uniqueness: true

  def set_current_deck(deck_id)
    update_attributes(current_deck_id: deck_id)
  end
end
