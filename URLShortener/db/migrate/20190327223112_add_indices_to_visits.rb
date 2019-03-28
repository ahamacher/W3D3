class AddIndicesToVisits < ActiveRecord::Migration[5.2]
  def change
    add_index :visits, :short_url
  end
end
