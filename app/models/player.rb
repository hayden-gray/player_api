class Player < ApplicationRecord
  enum :sport, [ :football, :basketball, :baseball ]

  validates :first_name, :last_name, :position, :age, :sport, :api_id, presence: true
  validates :age, numericality: { greater_than_or_equal_to: 1 }

  def average_position_age_diff
    avg = Player.where(
      sport: self.sport,
      position: self.position
    ).average(:age).to_i

    self.age.to_i - avg
  end
end
