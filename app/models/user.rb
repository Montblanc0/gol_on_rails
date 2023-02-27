class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_one :board, dependent: :destroy

  after_create :create_board

  def create_board
    puts "Creating board for user #{id}"
    create_board!
  end
end
