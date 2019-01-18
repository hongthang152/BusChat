class CreateDirectionQueries < ActiveRecord::Migration[5.2]
  def change
    create_table :direction_queries do |t|
      t.string :from
      t.string :to

      t.timestamps
    end
  end
end
