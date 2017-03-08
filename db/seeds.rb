Organization.create!(
  name: "Framgia Da Nang",
  description: Faker::Lorem.paragraph,
  phone: "0966077747",
  email: "framgia@framgia.com",
  location: "Da Nang"
)
Organization.create!(
  name: "FPT Da Nang Branch",
  description: Faker::Lorem.paragraph,
  phone: "0966077747",
  email: "framgia2@framgia.com",
  location: "Da Nang"
)
Organization.create!(
  name: "Axon Da Nang",
  description: Faker::Lorem.paragraph,
  phone: "0966077747",
  email: "framgia3@framgia.com",
  location: "Da Nang"
)
Organization.create!(
  name: "Evolabe Asian",
  description: Faker::Lorem.paragraph,
  phone: "0966077747",
  email: "framgia4@framgia.com",
  location: "Da Nang"
)

User.create!(
  email: "mahoangtienthanh@gmail.com",
  full_name: "Thanh ManCi",
  password: "mahoangtienthanh@gmail.com",
  phone: "0966.077.747"
)
User.create!(
  email: "longlyduc@gmail.com",
  full_name: "Ly Duc Long",
  password: "longlyduc@gmail.com",
  phone: "0123456789",
)
User.create!(
  email: "lequocviet@gmail.com",
  full_name: "Le Quoc Viet",
  password: "lequocviet@gmail.com",
  phone: "0123456789",
)
Admin.create!(
  email: "longlyduc@gmail.com",
  full_name: "Ly Duc Long",
  password: "longlyduc@gmail.com",
  phone: "0123456789",
)
50.times do |n|
  organization_id = 1
  club_name  = Faker::Name.name
  notification = Faker::Lorem.sentence
  description = Faker::Lorem.paragraph
  created_at = Faker::Time.between(20.days.ago, Date.today, :all)
  logo = Faker::Avatar.image
  image = Faker::Avatar.image
  Club.create!(
    organization_id: organization_id,
    name: club_name + " Club",
    notification: notification,
    description: description,
    created_at: created_at,
    logo: logo,
    rating: rand(1..5),
    image: image,
    is_active: true)
end
users = User.order(:created_at).take(2)
clubs = Club.order(:created_at).take(15)
clubs.each do |club|
  users.each do |user|
    UserClub.create!(
      club_id: club.id,
      user_id: user.id,
      is_manager: true
    )
  end
end

clubs = Club.all
clubs.each do |club|
  15.times do |n|
    event_name = Faker::Lorem.sentence
    description = Faker::Lorem.paragraph
    expense = Faker::Number.number(5)
    club_id = club.id
    event_category = rand(1..3)
    date_start = Faker::Time.between(20.days.ago, Date.today, :all)
    date_end = Faker::Time.between(20.days.ago, Date.today, :all)
    location = Faker::Address.city
    num_like = rand(0..100)
    created_at = Time.now + 2.month

    Event.create!(
      name: event_name,
      description: description,
      expense: expense,
      club_id: club_id,
      event_category: rand(1..3),
      date_start: date_start,
      date_end: date_end,
      location: location,
      num_like: num_like,
      created_at: created_at,
      user_id: rand(1..2)
    )
  end
end

OrganizationRequest.create!(
  user_id: User.last.id,
  name: "Pixelz Inc",
  description: Faker::Lorem.paragraph,
  phone: "09660725487",
  email: "Pixelz1@gmaiol.com",
  location: "Da Nang"
)

OrganizationRequest.create!(
  user_id: User.last.id,
  name: "Trong Nhan Inc",
  description: Faker::Lorem.paragraph,
  phone: "09660725487",
  email: "Pixelz2@gmaiol.com",
  location: "Da Nang"
)

OrganizationRequest.create!(
  user_id: User.last.id,
  name: "Tech Master Inc",
  description: Faker::Lorem.paragraph,
  phone: "09660725487",
  email: "Pixelz3@gmaiol.com",
  location: "Da Nang"
)

ClubRequest.create!(
  user_id: User.last.id,
  organization_id: Organization.last.id,
  name: "Bong Chuyen Club",
  description: Faker::Lorem.paragraph,
  action: "User send request"
)


ClubRequest.create!(
  user_id: User.last.id,
  organization_id: Organization.last.id,
  name: "Bong Da Club",
  description: Faker::Lorem.paragraph,
  action: "User send request"
)

ClubRequest.create!(
  user_id: User.first.id,
  organization_id: Organization.last.id,
  name: "Cau Long Club",
  description: Faker::Lorem.paragraph,
  action: "User send request"
)

3.times do |n|
  Message.create!(
    user_id: 1,
    club_id: Club.first.id,
    content: Faker::Lorem.sentence
  )

  Message.create!(
    user_id: 2,
    club_id: Club.first.id,
    content: Faker::Lorem.sentence
  )
end

UserOrganization.create!(
  user_id: 1,
  organization_id: 1,
  status: 1
)

UserOrganization.create!(
  user_id: 3,
  organization_id: 1,
  status: 1,
  is_admin: 1
)
