class AddBikouToAttendances < ActiveRecord::Migration[6.0]
  def change
    add_column :attendances, :bikou, :string
    add_column :attendances, :date_sankaku, :string
  end
end
