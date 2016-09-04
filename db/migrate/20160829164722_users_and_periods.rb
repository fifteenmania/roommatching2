class UsersAndPeriods < ActiveRecord::Migration
  def change
    create_table :users_periods, id: false do |t|
      t.belongs_to :user, index: true
      t.belongs_to :period, index: true
    end
  end
end
