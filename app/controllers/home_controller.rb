# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    current_token = DropboxToken.last.token
    @folders = DropboxApi::Client.new(current_token).list_folder("").entries
  end
end
