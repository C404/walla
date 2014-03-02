class TestOauthController < ApplicationController

	force_ssl
	before_filter :authenticate_user!

	def show
	end
end
