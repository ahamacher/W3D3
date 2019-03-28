# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

require 'faker'

ActiveRecord::Base.transaction do
  User.destroy_all

  users = []
  30.times { users << Faker::Internet.email }
  users.uniq!

  users.length.times { |i| User.create!(email: users[i]) }

  ShortenedUrl.destroy_all
  User.all.each { |user| ShortenedUrl.shorten(user, Faker::Internet.url)}

  30.times { Visit.record_visit!(User.all.sample, ShortenedUrl.all.sample) }

end