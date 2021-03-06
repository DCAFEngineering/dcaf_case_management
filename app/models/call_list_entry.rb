# Object representing a patient's call list.
class CallListEntry < ApplicationRecord
  # Relationships
  belongs_to :user
  belongs_to :patient

  # Validations
  validates :order_key, :line, presence: true
  validates :patient, uniqueness: { scope: :user }
end
