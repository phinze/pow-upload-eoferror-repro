class CreateTheaters < ActiveRecord::Migration
  def change
    create_table :theaters do |t|
      t.string :movie

      t.timestamps
    end
  end
end
