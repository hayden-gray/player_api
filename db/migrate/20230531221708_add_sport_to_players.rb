class AddSportToPlayers < ActiveRecord::Migration[7.0]
  def change
    add_column :players, :sport, :integer
  end
end
