class AddLinkToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :link, :string
    add_index :messages, :link, unique: true
  end
end
