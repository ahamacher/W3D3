require 'securerandom'
# == Schema Information
#
# Table name: shortened_urls
#
#  id         :bigint(8)        not null, primary key
#  long_url   :string           not null
#  short_url  :string           not null
#  author_id  :integer          not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ShortenedUrl < ApplicationRecord
  validates :long_url, presence: true

  belongs_to :submitter,
    primary_key: :id,
    foreign_key: :author_id,
    class_name: :User

  has_many :visits,
    primary_key: :id,
    foreign_key: :short_url_id,
    class_name: :Visit

  has_many :visitors,
    -> { distinct },
    through: :visits,
    source: :user

  def num_clicks
    self.visits.count
  end

  def num_uniques
    user_ids = self.visitors.select(:id)
    user_ids.count
  end 

  def num_recent_uniques
     user_ids = self.visits.select(:id).distinct.where( "updated_at > ?", 1.hour.ago )
      user_ids.count
  end 
  
  def self.random_code
    short_url = SecureRandom.urlsafe_base64 
    if ShortenedUrl.exists?(short_url)
      self.random_code
    end
    short_url
  end

  def self.shorten(user, long_url)
    ShortenedUrl.create!({
      long_url: long_url, 
      short_url: ShortenedUrl.random_code,
      author_id: user.id
    })
  end

  

end
