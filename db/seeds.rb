# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

FFdevice.create(longitude: 4.893894 , latitude: 52.376014, name: "Device 1", organization_id: 1, user_id: 1)
FFdevice.create(longitude: 4.898829 , latitude: 52.374678, name: "Device 2", organization_id: 1, user_id: 1)
FFdevice.create(longitude: 4.888058 , latitude: 52.370643, name: "Device 3", organization_id: 1, user_id: 1)
Token.create(token: "passpop")
User.create(email: "photographer1@example.com", password: "123123123", first_name: "photographer1", last_name: "flickfeeder", user_type: "photographer")
User.create(email: "photographer2@example.com", password: "123123123", first_name: "photographer2", last_name: "flickfeeder", user_type: "photographer")
