# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    current_token = DropboxToken.last.token
    @client = DropboxApi::Client.new(current_token)
    file_list = @client.list_folder('', recursive: true, limit: 300)
    file_entries = file_list.entries
    has_more = file_list.has_more?

    until has_more == false
      current_file_list = @client.list_folder_continue(file_list.cursor)
      file_entries += current_file_list.entries
      Rails.logger.info("file_entries count: #{file_entries.count}")
      has_more = current_file_list.has_more?
    end

    all_files = file_entries.select { |entry| entry.is_a?(DropboxApi::Metadata::File) }

    file_types = all_files.map { |file| file.name.split('.').last }.uniq

    @file_type_counts = Hash[file_types.map { |file_type| [file_type, all_files.select {|file| file.name.split('.').last == file_type}.count] }]
  end
end
