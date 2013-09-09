class CreateKids < ActiveRecord::Migration
  def change
    create_table :kids do |t|
      t.string :name
      t.integer :age
      t.string :picture, default: 'no_image.png'
      t.boolean :lost
      t.date :time
      t.integer :credits
      t.integer :user_id

      t.timestamps
    end

    add_index :kids, :lost
    add_index :kids, :time
  end
end

