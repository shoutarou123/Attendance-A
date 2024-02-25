# coding: utf-8

User.create!(name: "Sample User",
             email: "sample@email.com",
             affiliation: "管理者",
             employee_number: 1,
             uid: 001,
             password: "password",
             password_confirmation: "password",
             admin: true) # 管理者だけが管理権限持つようにしている

User.create!(name: "上長A",
             email: "sample-A@email.com",
             employee_number: 2,
             uid: 002,
             password: "password",
             password_confirmation: "password",
             role: "superior",
             superior: true)
             
             User.create!(name: "上長B",
             email: "sample-B@email.com",
             employee_number: 3,
             uid: 003,
             password: "password",
             password_confirmation: "password",
             role: "superior",
             superior: true)
             
             User.create!(name: "一般C",
             email: "sample-C@email.com",
             employee_number: 4,
             uid: 004,
             password: "password",
             password_confirmation: "password")
             
             User.create!(name: "一般D",
             email: "sample-D@email.com",
             employee_number: 5,
             uid: 005,
             password: "password",
             password_confirmation: "password")
             
BasePoint.create!(number: 1,
                  name: "拠点１",
                  attendance_type: "出勤")
BasePoint.create!(number: 2,
                  name: "拠点２",
                  attendance_type: "出勤")

10.times do |n|
  name  = Faker::Name.name
  email = "sample-#{n+1}@email.com"
  password = "password"
  User.create!(name: name,
               email: email,
               password: password,
               password_confirmation: password)
end