# Create some ENTRY users
3.times do |n|
  email = "entry-user-#{n+1}@csc495.org"
  password = "password"
  User.create!(username:               "entry-user#{n+1}",
              email:                  email,
              password_digest:        password,
              permission_level:       0,
              super_admin:            false)
end

# Create some STANDARD users
3.times do |n|
  email = "std-user-#{n+1}@csc495.org"
  password = "password"
  User.create!(username:               "std-user#{n+1}",
              email:                  email,
              password_digest:        password,
              permission_level:       1,
              super_admin:            false)
end

# Create some ADMIN users
3.times do |n|
  email = "admin-user-#{n+1}@csc495.org"
  password = "password"
  User.create!(username:               "admin-user#{n+1}",
              email:                  email,
              password_digest:        password,
              permission_level:       2,
              super_admin:            false)
end

# Create 1 Super Admin
User.create!(username:               "superadmin",
              email:                  "superadmin@site.com",
              password_digest:        "password",
              permission_level:       2,
              super_admin:            true)

# Create some days
20.times do |n|
  d = Date.today + (n).days
  if(!d.saturday? && !d.sunday?)
    Day.create!(date: d)
  end
end

Pickup.create!(
            day_id:                       1,
            donor_first_name:             "Anthony",
            donor_last_name:              "Rizzo",
            donor_address_line1:          "1060 W Addison St",
            donor_address_line2:          "Suite 101",
            donor_city:                   "Chicago",
            donor_zip:                    "60613",
            donor_dwelling_type:          "Historic Ball Park",
            donor_phone:                  "(773) 404-2827",
            donor_email:                  "rizzo@cubs.com",
            number_of_items:               1,
            item_notes:                   "Autographed baseball"
)

Pickup.create!(
            day_id:                       1,
            donor_first_name:             "Mark",
            donor_last_name:              "Christianson",
            donor_address_line1:          "1233 Chanticleer Ave",
            donor_address_line2:          "Apartment D",
            donor_city:                   "Bolingbrook",
            donor_zip:                    "55555",
            donor_dwelling_type:          "Mini-House",
            donor_phone:                  "(555) 555-5555",
            donor_email:                  "mark.christianson@mheducation.com",
            number_of_items:               5,
            item_notes:                   "table/4 chairs, china cabinet (matching set)"
)