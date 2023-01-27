class CreateDropboxTokens < ActiveRecord::Migration[6.1]
  def change
    create_table :dropbox_tokens do |t|
      t.string :token

      t.timestamps
    end
  end
end
