class CreateOption < ActiveRecord::Migration
  def change
    create_table :options do |t|
      t.datetime :delete_at
      t.integer :delete_after_views
    end

    add_reference :options, :message, index: true, foreign_key: true
  end
end
