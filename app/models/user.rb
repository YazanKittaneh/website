class User < ActiveRecord::Base
  attr_accessible :name, :oauth_expires_at, :oauth_token, :provider, :uid

  def self.from_omniauth(auth)
    user = auth.slice(:provider, :uid)

    # return nil if user isn't authorized (array with users is found in environments)
    # TODO: fix facebook login
    #unless APP_CONFIG["facebook_authorized_users"].include? user[:uid]
    #  return nil
    #end

    where(user).first_or_initialize.tap do |user|
      user.provider = auth.provider
      user.uid = auth.uid
      user.name = auth.info.name
      user.oauth_token = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at)
      user.save!
    end
  end
end
