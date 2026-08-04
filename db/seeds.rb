require "open-uri"

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

used_rpps_numbers = Set.new
generate_rpps_number = lambda do
  loop do
    number = [rand(1..9), *Array.new(10) { rand(0..9) }].join
    break number if used_rpps_numbers.add?(number)
  end
end

used_portraits = Set.new
attach_nurse_photo = lambda do |nurse|
  gender_folder = nurse.female? ? "women" : "men"

  loop do
    index = rand(0..99)
    key = "#{gender_folder}-#{index}"
    next unless used_portraits.add?(key)

    nurse.photo.attach(
      io: URI.open("https://randomuser.me/api/portraits/#{gender_folder}/#{index}.jpg"),
      filename: "nurse_#{nurse.id}.jpg",
      content_type: "image/jpeg"
    )
    break
  end
end

puts "Création des utilisateurs..."
users = [
  User.create!(first_name: "Jean",   last_name: "Dupont",  email: "jean@gmail.com",   password: "password", phone: "0612345678", commune: "Paris"),
  User.create!(first_name: "Marie",  last_name: "Laurent", email: "marie@gmail.com",  password: "password", phone: "0623456789", commune: "Lyon"),
  User.create!(first_name: "Thomas", last_name: "Renard",  email: "thomas@gmail.com", password: "password", phone: "0634567890", commune: "Marseille"),
  User.create!(first_name: "Sophie", last_name: "Martin",  email: "sophie@gmail.com", password: "password", phone: "0645678901", commune: "Paris"),
  User.create!(first_name: "Lucas",  last_name: "Petit",   email: "lucas@gmail.com",  password: "password", phone: "0656789012", commune: "Lyon"),
]

def review_comment_templates(nurse)
  professionnel = nurse.female? ? "professionnelle" : "professionnel"
  ponctuel      = nurse.female? ? "ponctuelle" : "ponctuel"
  doux          = nurse.female? ? "douce" : "doux"
  rassurant     = nurse.female? ? "Rassurante" : "Rassurant"
  competent     = nurse.female? ? "compétente" : "compétent"
  attentionne   = nurse.female? ? "attentionnée" : "attentionné"
  serieux       = nurse.female? ? "sérieuse" : "sérieux"
  un_e_vrai_e   = nurse.female? ? "Une vraie" : "Un vrai"

  [
    "Très #{professionnel}, #{ponctuel} et #{doux}. Je recommande vivement.",
    "Excellente prise en charge pour ma mère. #{rassurant} et #{competent}.",
    "Réactivité exemplaire, disponible rapidement pour une urgence.",
    "Soins de grande qualité, très #{attentionne} et à l'écoute.",
    "Prestation très satisfaisante, les soins ont été effectués avec soin et professionnalisme.",
    "Toujours disponible et très aimable. Je recommande sans hésitation.",
    "#{un_e_vrai_e} #{professionnel}, #{doux} et efficace. Merci !",
    "#{ponctuel.capitalize} et très #{serieux}. Mes parents sont en de bonnes mains.",
  ]
end

puts "Création des infirmiers génériques..."
nurses_data = [
  { first_name: "Marc",    last_name: "Dubois",   email: "marc.dubois@nursy.fr",    rpps_number: generate_rpps_number.call, commune: commune_paris },
  { first_name: "Claire",  last_name: "Fontaine", email: "claire.fontaine@nursy.fr", rpps_number: generate_rpps_number.call, commune: commune_lyon },
  { first_name: "Antoine", last_name: "Simon",    email: "antoine.simon@nursy.fr",   rpps_number: generate_rpps_number.call, commune: commune_marseille },
  { first_name: "Léa",     last_name: "Rousseau", email: "lea.rousseau@nursy.fr",    rpps_number: generate_rpps_number.call, commune: commune_lyon },
  { first_name: "Hugo",    last_name: "Garnier",  email: "hugo.garnier@nursy.fr",    rpps_number: generate_rpps_number.call, commune: commune_paris },
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
  attach_nurse_photo.call(nurse)

  specialty_objects.sample(rand(1..2)).each { |s| NurseSpecialty.create!(nurse: nurse, specialty: s) }

  availabilities = (0..3).flat_map do |j|
    [8, 9, 10, 11, 14, 15, 16, 17].sample(3).map do |hour|
      Availability.create!(
        nurse: nurse,
        start_time: DateTime.now.beginning_of_day + j.days + hour.hours,
        end_time:   DateTime.now.beginning_of_day + j.days + hour.hours + 1.hour,
        is_booked: false
      )
    end
  end

  available_comments = review_comment_templates(nurse).shuffle
  users.sample(rand(2..4)).each do |user|
    availability = availabilities.reject(&:is_booked).sample
    next unless availability

    appointment = Appointment.create!(
      nurse: nurse,
      user: user,
      availability: availability
    )
    availability.update!(is_booked: true)
    Review.create!(
      nurse:       nurse,
      user:        user,
      appointment: appointment,
      rating:      rand(4..5),
      comment:     available_comments.pop
    )
  end
end

puts "Création des infirmiers à Paris..."
paris_nurses = [
  { first_name: "Camille", last_name: "Moreau",  rpps_number: generate_rpps_number.call },
  { first_name: "Julien",  last_name: "Bernard",  rpps_number: generate_rpps_number.call },
  { first_name: "Sophie",  last_name: "Lefèvre", rpps_number: generate_rpps_number.call },
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
  attach_nurse_photo.call(nurse)

  specialty_objects.sample(rand(1..2)).each { |s| NurseSpecialty.create!(nurse: nurse, specialty: s) }

  availabilities = (0..3).flat_map do |j|
    [8, 9, 10, 11, 14, 15, 16, 17].sample(3).map do |hour|
      Availability.create!(
        nurse: nurse,
        start_time: DateTime.now.beginning_of_day + j.days + hour.hours,
        end_time:   DateTime.now.beginning_of_day + j.days + hour.hours + 1.hour,
        is_booked: false
      )
    end
  end

  available_comments = review_comment_templates(nurse).shuffle
  users.sample(rand(3..5)).each do |user|
    availability = availabilities.reject(&:is_booked).sample
    next unless availability

    appointment = Appointment.create!(
      nurse: nurse,
      user: user,
      availability: availability
    )
    availability.update!(is_booked: true)
    Review.create!(
      nurse:       nurse,
      user:        user,
      appointment: appointment,
      rating:      rand(4..5),
      comment:     available_comments.pop
    )
  end
end

puts "Base de données générée avec succès ! 🎉"