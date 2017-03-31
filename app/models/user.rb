class User < ApplicationRecord
  acts_as_taggable

  devise :database_authenticatable, :registerable, :recoverable, :rememberable,
    :trackable, :validatable

  has_many :ratings, as: :rateable
  has_many :user_organizations, dependent: :destroy
  has_many :organizations, through: :user_organizations
  has_many :user_organizations, dependent: :destroy
  has_many :user_clubs, dependent: :destroy
  has_many :user_events, dependent: :destroy
  has_many :events, dependent: :destroy
  has_many :club_requests, dependent: :destroy
  has_many :organization_requests, dependent: :destroy
  has_many :images
  has_many :comments, dependent: :destroy
  has_many :reason_leaves, dependent: :destroy
  has_many :news, dependent: :destroy
  has_many :clubs, through: :user_clubs
  has_many :events, through: :user_events
  has_many :notifications, as: :target, dependent: :destroy
  has_many :target_hobbies_tags, as: :target, dependent: :destroy
  has_many :activities, as: :person_target, dependent: :destroy
  has_many :messages, dependent: :destroy

  mount_uploader :avatar, AvatarUploader

  scope :newest, -> {order created_at: :desc}
  scope :eliminate, -> user {where.not id: user.id}
  scope :yet_by_ids, -> ids {where.not id: ids}
  scope :done_by_ids, -> ids {where id: ids}

  validates :full_name, presence: true, length: {maximum: Settings.max_name}
  validates :password, presence: true, length: {minimum: Settings.min_password}, on: :create
  validate :validate_tags

  def joined_organization? organization
    self.user_organizations.joined.join?(organization)
  end

  def pending_organization? organization
    self.user_organizations.pending.join?(organization)
  end

  def validate_tags
    errors.add(:tag_list) if tag_list.size > Settings.limit_tags
  end

  def is_user? user
    self == user
  end

  def tags_clubs
    organizaitons = Organization.by_user_organizations(
      self.user_organizations.joined)
    arr = []
    club = Club.of_organizations(organizations)
    self.tag_list.each do |tag|
      if club.tagged_with(tag).any?
        club.tagged_with(tag).each do |club|
          arr << club
        end
      end
    end
    arr
  end
end
