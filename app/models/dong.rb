class Dong < ActiveRecord::Base
    serialize :metadata, Oj
    
    has_and_belongs_to_many :users
    belongs_to :univ, dependent: :destroy
    
    def as_json(options={})
       return super.as_json(only: [:id, :name]) 
    end
end
