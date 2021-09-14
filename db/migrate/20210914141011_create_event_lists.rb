class CreateEventLists < ActiveRecord::Migration[6.0]
  def change
    create_table :event_lists do |t|
      t.integer :event_id
      t.text :name

      t.timestamps
    end
  end
end
