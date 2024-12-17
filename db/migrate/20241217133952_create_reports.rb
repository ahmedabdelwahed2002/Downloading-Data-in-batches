class CreateReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reports do |t|
      t.string :name
      t.integer :total

      t.timestamps
    end
  end
end
