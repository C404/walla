class Provider < ActiveRecord::Base
	attr_accessible :expires, :expires_at, :provider, :token, :uid, :refresh_token, :email
	validates :provider, :token, :uid, presence: true
	validates :expires, :inclusion => { :in => [true, false] }
	belongs_to :user
end
