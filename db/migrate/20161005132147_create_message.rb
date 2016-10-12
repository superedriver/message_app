class CreateMessage < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.text :text
    end
  end
end
