class AddYmToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :ym, :integer
  end
end
