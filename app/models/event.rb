class Event < ApplicationRecord
  has_many :news, dependent: :destroy
  has_many :user_events, dependent: :destroy
  has_many :users, through: :user_events
  has_many :comments, as: :target, dependent: :destroy
  has_many :budgets, dependent: :destroy
  has_many :notifications, as: :target, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy

  belongs_to :club
  belongs_to :user

  mount_uploader :image, ImageUploader

  validates :name, presence: true, length: {minimum: Settings.min_name}
  validates :expense, length: {maximum: Settings.max_exspene}
  validates :location, length: {maximum: Settings.max_location}
  validates :description, length: {maximum: Settings.max_description}

  scope :top_like, -> {order num_like: :desc}
  scope :of_month_payment, -> month_payment {where month_of_payment: month_payment}
  scope :newest, -> {order created_at: :desc}
  scope :periodic, -> {where event_category: Settings.periodic_category}
  scope :by_current_year, -> {where "year(created_at) = ?", Time.zone.now.year}
  scope :by_quarter, -> months {where("month(created_at) in (?)", months)}
  scope :of_category, -> event_category {where event_category: event_category}

  enum status: {inprocess: 0, finished: 1}
  enum event_category: {pay_money: 1, get_money: 2, notification: 3, subsidy: 0}

  def self.group_by_quarter
    quarters = [[1,2,3], [4,5,6], [7,8,9], [10,11,12]]
    array = Array.new
    quarters.each_with_index do |quarter, index|
      list_events = self.by_quarter quarters[index]
      array.push list_events
    end
    array
  end

  def cost_expense total
    self.update_attributes expense: self.expense.to_i + self.amount.to_i * total
  end
end
