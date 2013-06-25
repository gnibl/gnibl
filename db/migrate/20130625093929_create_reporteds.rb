class CreateReporteds < ActiveRecord::Migration
  def change
    create_table :reporteds do |t|
      t.integer :gnib_id
      t.integer :reporter_id
      t.string :status

      t.timestamps
    end
  end
end
