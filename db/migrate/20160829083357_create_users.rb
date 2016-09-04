class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ""
      t.string :image
      t.string :gender
      t.string :token
      
      t.string :name
      t.string :major
      t.string :birth
      t.string :stage
      
      t.belongs_to :univ, index: true
      t.timestamps null: false
    end
    
    add_index :users, :email,                unique: true
    add_index :users, :token,                unique: true
  end
end
