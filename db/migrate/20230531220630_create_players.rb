class CreatePlayers < ActiveRecord::Migration[7.0]
  def change
    create_table :players do |t|
      t.string :first_name
      t.string :last_name
      t.string :name_brief
      t.string :position
      t.integer :age

      t.timestamps
    end
  end
end
