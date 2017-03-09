class Budget < ApplicationRecord
  belongs_to :event
  belongs_to :user

  def self.of_user user_id, event_id
    find_by user_id: user_id, event_id: event_id
  end
end
