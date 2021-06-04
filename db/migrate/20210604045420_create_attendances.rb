class CreateAttendances < ActiveRecord::Migration[6.0]
  def change
    create_table :attendances do |t|
      t.text :username
      t.text :date

      t.timestamps
    end
  end
end
