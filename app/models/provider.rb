class Provider < ActiveRecord::Base
	validates :provider, :token, :uid, presence: true
	validates :expires, :inclusion => { :in => [true, false] }
	belongs_to :user
end
