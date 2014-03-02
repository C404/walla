# -*- coding: utf-8 -*-

class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  skip_before_filter :authenticate_user
  
  def salesforce
    proceed
  end

  private

  def proceed
    omniauth = request.env["omniauth.auth"]
    omniauth_to_session(omniauth)


    @user = User.find_for_oauth(omniauth)

    if current_user.nil? and @user.nil?
      # user logout and no gateway associated
      if (u = User.find_by_email(session[:omniauth][omniauth.provider.to_sym][:info][:email]))
        # user alread registered we propose to login thorugh existing gateway
        providers = u.providers.map(&:provider)
        providers.push('normal login') if providers.empty?
        flash[:show_providers] = providers
        redirect_to new_user_session_url(state: params[:state]), notice: "An account already exist with this email #{u.email} try to signin with ... #{providers.join(', ')} in order to associate them to your account"
        return
      else
        email = omniauth[:info][:email]
        password = (0...8).map { (65 + rand(26)).chr }.join
        @user = User.create!(email: email, password: password, password_confirmation: password, first_name: omniauth[:info][:first_name], last_name: omniauth[:info][:last_name])
      end
    end
    
    if current_user and @user and current_user != @user
      sign_out current_user
    end
    if !@user.nil? and @user.persisted?
     sign_in @user, :event => :authentication
   end
     # we synchronize providers to the db
     current_user.assign_providers_from_session(session)
     puts 'hello ' + params[:state]
     puts params[:state] =~ URI::regexp
     puts (params[:state] and params[:state] =~ URI::regexp) ? params[:state] : root_url
     redirect_to((params[:state] and params[:state] =~ URI::regexp) ? params[:state] : root_url, notice: "Login réussi !")
    # check valid URL
  end

  def omniauth_to_session omniauth
    omniauth.except!(:extra)
    omniauth.info.except!(:urls)

    session_var = omniauth.provider.to_sym
    session[:omniauth] = {} if session[:omniauth].nil?
    session[:omniauth][session_var] = omniauth

    credentials = session[:omniauth][session_var][:credentials]

    credentials[:expires_at] = Time.at(credentials[:expires_at]) if credentials[:expires] && credentials[:expires_at]
  end
end

