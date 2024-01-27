# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             affiliation: "管理者",
             employee_number: 1,
             uid: 001,
             password: "password",
             password_confirmation: "password",
             admin: true) # 管理者だけが管理権限持つようにしている

60.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end