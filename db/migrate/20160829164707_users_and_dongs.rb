class UsersAndDongs < ActiveRecord::Migration
  def change
    create_table :users_dongs, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :dong, index: true
    end
  end
end
