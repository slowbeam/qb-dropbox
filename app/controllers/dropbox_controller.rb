class DropboxController < ApplicationController
  # Example call:
  # GET /dropbox/auth
  def auth
    url = authenticator.auth_code.authorize_url + "&redirect_uri=#{redirect_uri}"
    redirect_to(url)
  end

  # Example call:
  # GET /dropbox/auth_callback?code=VofXAX8DO1sAAAAAAAACUKBwkDZyMg1zKT0f_FNONeA
  def auth_callback
    auth_bearer = authenticator.get_token({ code: params[:code], grant_type: "authorization_code", redirect_uri: redirect_uri })
    token = auth_bearer.token # This line is step 5 in the diagram.
    @current_token = DropboxToken.create(token: token)
    # At this stage you may want to persist the reusable token we've acquired.
    # Remember that it's bound to the Dropbox account of your user.

    # If you persist this token, you can use it in subsequent requests or
    # background jobs to perform calls to Dropbox API such as the following.
    redirect_to(root_path)
  end

  private

  def authenticator
    @_authenticator ||= DropboxApi::Authenticator.new(ENV["CLIENT_ID"], ENV["CLIENT_SECRET"])
  end

  def redirect_uri
    dropbox_auth_callback_url # => http://localhost:3000/dropbox/auth_callback
  end
end
