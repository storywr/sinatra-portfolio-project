class CreateTeams < ActiveRecord::Migration[5.0]
  def change
    create_table :teams do |t|
      t.string :name
      t.string :qb
      t.string :rb
      t.string :wr
      t.string :te
      t.string :defense
      t.string :kicker
      t.integer :user_id
    end
  end
end
