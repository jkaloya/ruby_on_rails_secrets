class Secret < ActiveRecord::Base
    belongs_to :user
    has_many :likes, dependent: :destroy
    has_many :user_likes, through: :likes, source: :user
    validates :content, presence: true
end
