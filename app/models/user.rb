class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
  :recoverable, :rememberable, :trackable, :validatable

  devise :omniauthable, :omniauth_providers => [:salesforce]


  has_many :providers

  def self.find_for_oauth(auth)
  	provider = Provider.where(provider: auth.provider, uid: auth.uid).first
  	(provider.nil? ? nil : provider.user)
  end

  def assign_providers_from_session(session)
  	if session[:omniauth].respond_to? :each
  		session[:omniauth].each do |k, provider|
  			provider_model = Provider.where(provider: provider[:provider], uid: provider[:uid]).first
  			if provider_model.nil?
  				provider_model = Provider.new
  				provider_model.email = self.email
  			end
        attrs = provider.credentials.except(:instance_url).merge({provider: provider[:provider], uid: provider[:uid]}).to_hash
        # raise attrs.inspect

        provider_model.assign_attributes(attrs) # could use slice or except...
        provider_model.user = self
        provider_model.save!

        if provider[:extra].is_a? Hash and provider[:extra][:raw_info].is_a? Hash
        	info = provider[:extra][:raw_info]
        	self.gender = info[:gender] if self.gender.blank? and info[:gender]
        	begin
        		self.birthday = Date.strptime(info[:birthday], '%m/%d/%Y') if self.birthday.blank? and info[:birthday]
        	rescue
        	end
        end
      end
    end
    save
  end


  def first_name=(f)
   write_attribute :first_name, f.capitalize
 end

 def last_name=(l)
   write_attribute :last_name, l.capitalize
 end

 def to_s
   "#{first_name} #{last_name} #{email}"
 end

end
