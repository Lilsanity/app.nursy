puts "Nettoyage de la base de données..."
Review.destroy_all
Appointment.destroy_all
Availability.destroy_all
NurseSpecialty.destroy_all
Nurse.destroy_all
Specialty.destroy_all
Commune.destroy_all
User.destroy_all

puts "Création des communes..."
commune_paris     = Commune.create!(name: "Paris",     postal_code: "75001", latitude: 48.8566, longitude: 2.3522)
commune_lyon      = Commune.create!(name: "Lyon",      postal_code: "69001", latitude: 45.7640, longitude: 4.8357)
commune_marseille = Commune.create!(name: "Marseille", postal_code: "13001", latitude: 43.2965, longitude: 5.3698)

puts "Création des spécialités..."
specialties = ["Pédiatrie", "Gériatrie", "Soins Palliatifs", "Pansements complexes", "Vaccination"]
specialty_objects = specialties.map { |name| Specialty.create!(name: name) }

puts "Création des utilisateurs..."
users = [
  User.create!(first_name: "Jean",   last_name: "Dupont",  email: "jean@gmail.com",   password: "password", phone: "0612345678", commune: "Paris"),
  User.create!(first_name: "Marie",  last_name: "Laurent", email: "marie@gmail.com",  password: "password", phone: "0623456789", commune: "Lyon"),
  User.create!(first_name: "Thomas", last_name: "Renard",  email: "thomas@gmail.com", password: "password", phone: "0634567890", commune: "Marseille"),
  User.create!(first_name: "Sophie", last_name: "Martin",  email: "sophie@gmail.com", password: "password", phone: "0645678901", commune: "Paris"),
  User.create!(first_name: "Lucas",  last_name: "Petit",   email: "lucas@gmail.com",  password: "password", phone: "0656789012", commune: "Lyon"),
]

review_comments = [
  "Très professionnel(le), ponctuel(le) et doux(douce). Je recommande vivement.",
  "Excellente prise en charge pour ma mère. Rassurant(e) et compétent(e).",
  "Réactivité exemplaire, disponible rapidement pour une urgence.",
  "Soins de grande qualité, très attentionné(e) et à l'écoute.",
  "Je suis très satisfait(e). Les soins ont été effectués avec soin et professionnalisme.",
  "Toujours disponible et très aimable. Je recommande sans hésitation.",
  "Une vraie professionnelle, douce et efficace. Merci !",
  "Ponctuel(le) et très sérieux(se). Mes parents sont en de bonnes mains.",
]

puts "Création des infirmiers génériques..."
nurses_data = [
  { first_name: "Marc",    last_name: "Dubois",   email: "marc.dubois@nursy.fr",    rpps_number: "10000098765", commune: commune_paris },
  { first_name: "Claire",  last_name: "Fontaine", email: "claire.fontaine@nursy.fr", rpps_number: "10001098765", commune: commune_lyon },
  { first_name: "Antoine", last_name: "Simon",    email: "antoine.simon@nursy.fr",   rpps_number: "10002098765", commune: commune_marseille },
  { first_name: "Léa",     last_name: "Rousseau", email: "lea.rousseau@nursy.fr",    rpps_number: "10003098765", commune: commune_lyon },
  { first_name: "Hugo",    last_name: "Garnier",  email: "hugo.garnier@nursy.fr",    rpps_number: "10004098765", commune: commune_paris },
]

nurses_data.each do |attrs|
  nurse = Nurse.create!(
    first_name:     attrs[:first_name],
    last_name:      attrs[:last_name],
    email:          attrs[:email],
    rpps_number:    attrs[:rpps_number],
    commune:        attrs[:commune],
    average_rating: rand(3.5..5.0).round(1),
    is_verified:    true
  )

  specialty_objects.sample(rand(1..2)).each { |s| NurseSpecialty.create!(nurse: nurse, specialty: s) }

  availabilities = 3.times.map do |j|
  hour = [8, 9, 10, 11, 14, 15, 16, 17].sample
  Availability.create!(
    nurse: nurse,
    start_time: DateTime.now.beginning_of_day + j.days + hour.hours,
    end_time:   DateTime.now.beginning_of_day + j.days + hour.hours + 1.hour,
    is_booked: false
  )
  end

  users.sample(rand(2..4)).each do |user|
    availability = availabilities.sample
    appointment = Appointment.create!(
      nurse: nurse,
      user: user,
      availability: availability
    )
    Review.create!(
      nurse:       nurse,
      user:        user,
      appointment: appointment,
      rating:      rand(4..5),
      comment:     review_comments.sample
    )
  end
end

puts "Création des infirmiers à Paris..."
paris_nurses = [
  { first_name: "Camille", last_name: "Moreau",  rpps_number: "10010001111" },
  { first_name: "Julien",  last_name: "Bernard",  rpps_number: "10010002222" },
  { first_name: "Sophie",  last_name: "Lefèvre", rpps_number: "10010003333" },
]

paris_nurses.each do |attrs|
  nurse = Nurse.create!(
    first_name:     attrs[:first_name],
    last_name:      attrs[:last_name],
    email:          "#{attrs[:first_name].downcase}.#{attrs[:last_name].downcase}@nursy.fr",
    rpps_number:    attrs[:rpps_number],
    commune:        commune_paris,
    average_rating: rand(4.0..5.0).round(1),
    is_verified:    true
  )

  specialty_objects.sample(rand(1..2)).each { |s| NurseSpecialty.create!(nurse: nurse, specialty: s) }

  availabilities = 3.times.map do |j|
  hour = [8, 9, 10, 11, 14, 15, 16, 17].sample
  Availability.create!(
    nurse: nurse,
    start_time: DateTime.now.beginning_of_day + j.days + hour.hours,
    end_time:   DateTime.now.beginning_of_day + j.days + hour.hours + 1.hour,
    is_booked: false
  )
  end

  users.sample(rand(3..5)).each do |user|
    availability = availabilities.sample
    appointment = Appointment.create!(
      nurse: nurse,
      user: user,
      availability: availability
    )
    Review.create!(
      nurse:       nurse,
      user:        user,
      appointment: appointment,
      rating:      rand(4..5),
      comment:     review_comments.sample
    )
  end
end

puts "Base de données générée avec succès ! 🎉"