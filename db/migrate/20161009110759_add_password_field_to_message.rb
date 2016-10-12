class AddPasswordFieldToMessage < ActiveRecord::Migration
  def change
    add_column :messages, :password, :string
  end
end
