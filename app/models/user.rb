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
  scope :done_by_emails, -> emails {where email: emails}

  validates :full_name, presence: true, length: {maximum: Settings.max_name}
  validates :password, presence: true, length: {minimum: Settings.min_password}, on: :create
  #validate :validate_tags

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

  def self.import_file(file, organization)
    users = []
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(Settings.read_key_row1)
    (Settings.read_data_row2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = find_by_id(row["id"]) || new
      user.attributes = row.to_hash.slice(*row.to_hash.keys)
      users << user
    end
    if User.done_by_emails(users.map(&:email)).any?
      @errors = Settings.error_data
    else
      User.import users
      @users = User.done_by_emails users.map(&:email)
      @users.each do |user|
        UserOrganization.create_user_organization user.id, organization.id
      end
    end
  end

  def self.open_spreadsheet(file)
    @errors = []
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else
      @errors = Settings.error_import
    end
  end

  def password_required?
    encrypted_password.blank? || encrypted_password_changed?
  end
end
