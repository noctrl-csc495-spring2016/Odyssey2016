# Create Prof. Bill
User.create!(
  username:           "profbill",
  email:              "wtkrieger@noctrl.edu",
  password_digest:    User.digest("password"),
  permission_level:   2,
  super_admin:        true
)