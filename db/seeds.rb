User.destroy_all

puts "Creating Admin User..."

User.create!(email: "tom@test.com", password: "password123")

puts "Done!"
