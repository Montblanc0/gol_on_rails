class Board < ApplicationRecord
  belongs_to :user, optional: false

  with_options presence: true do
    validates :user
    validates :size, numericality: { greater_than_or_equal_to: 10, less_than_or_equal_to: 100 }
    validates :gen, numericality: { greater_than_or_equal_to: 1 }
  end
end
