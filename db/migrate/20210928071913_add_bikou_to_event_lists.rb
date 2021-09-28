class AddBikouToEventLists < ActiveRecord::Migration[6.0]
  def change
    add_column :event_lists, :bikou, :string
    add_column :event_lists, :password_digest, :string
  end
end
