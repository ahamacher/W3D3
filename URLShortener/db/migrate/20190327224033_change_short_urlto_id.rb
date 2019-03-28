class ChangeShortUrltoId < ActiveRecord::Migration[5.2]
  def change
    add_column :visits, :short_url_id, :integer, null: false
    remove_column :visits, :short_url
  end
end
