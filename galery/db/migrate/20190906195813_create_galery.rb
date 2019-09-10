class CreateGalery < ActiveRecord::Migration
  def change
    create_table :galeries do |t|
      t.string :name
      t.text :description
      t.integer :user_id
    end
  end
end
