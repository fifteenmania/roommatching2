class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email,              null: false, default: ""
      t.string :provider
      t.string :image
      t.string :gender
      
      t.string :name
      t.string :major
      t.string :birth
      t.string :stage
      
      t.belongs_to :univ, index: true
      t.belongs_to :dong1, index: true
      t.belongs_to :dong2, index: true
      t.belongs_to :period1, index: true
      t.belongs_to :period2, index: true
      t.timestamps null: false
    end
    
    add_index :users, :email,                unique: true
  end
end
