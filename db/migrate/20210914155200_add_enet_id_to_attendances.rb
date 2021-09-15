class AddEnetIdToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :event_id, :integer
  end
end
