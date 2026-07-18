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
commune_paris = Commune.create!(name: "Paris", postal_code: "75001", latitude: 48.8566, longitude: 2.3522)
commune_lyon = Commune.create!(name: "Lyon", postal_code: "69001", latitude: 45.7640, longitude: 4.8357)
commune_marseille = Commune.create!(name: "Marseille", postal_code: "13001", latitude: 43.2965, longitude: 5.3698)

puts "Création des spécialités..."
specialties = ["Pédiatrie", "Gériatrie", "Soins Palliatifs", "Pansements complexes", "Vaccination"]
specialty_objects = specialties.map do |spec_name|
  Specialty.create!(name: spec_name)
end

puts "Création des utilisateurs..."
test_user = User.create!(
  first_name: "Jean",
  last_name: "Dupont",
  email: "jean@gmail.com",
  password: "password",
  phone: "0612345678",
  commune: "Paris"
)

puts "Création des infirmiers..."
5.times do |i|
  nurse = Nurse.create!(
    first_name: "Nurse_FN_#{i}",
    last_name: "Nurse_LN_#{i}",
    email: "nurse#{i}@nursy.fr",
    rpps_number: "1000#{i}98765",
    commune: [commune_paris, commune_lyon, commune_marseille].sample,
    average_rating: rand(3.5..5.0).round(1),
    is_verified: true
  )

  nurse_specs = specialty_objects.sample(rand(1..2))
  nurse_specs.each do |spec|
    NurseSpecialty.create!(nurse: nurse, specialty: spec)
  end

  3.times do |j|
    Availability.create!(
      nurse: nurse,
      start_time: DateTime.now + j.days + 2.hours,
      end_time: DateTime.now + j.days + 3.hours,
      is_booked: false
    )
  end
end

puts "Création des infirmiers à Paris..."
paris_nurses = [
  { first_name: "Camille", last_name: "Moreau", rpps_number: "10010001111" },
  { first_name: "Julien", last_name: "Bernard", rpps_number: "10010002222" },
  { first_name: "Sophie", last_name: "Lefèvre", rpps_number: "10010003333" }
]

paris_nurses.each do |attrs|
  nurse = Nurse.create!(
    first_name: attrs[:first_name],
    last_name: attrs[:last_name],
    email: "#{attrs[:first_name].downcase}.#{attrs[:last_name].downcase}@nursy.fr",
    rpps_number: attrs[:rpps_number],
    commune: commune_paris,
    average_rating: rand(3.5..5.0).round(1),
    is_verified: true
  )

  nurse_specs = specialty_objects.sample(rand(1..2))
  nurse_specs.each do |spec|
    NurseSpecialty.create!(nurse: nurse, specialty: spec)
  end

  3.times do |j|
    Availability.create!(
      nurse: nurse,
      start_time: DateTime.now + j.days + 2.hours,
      end_time: DateTime.now + j.days + 3.hours,
      is_booked: false
    )
  end
end

puts "Base de données générée avec succès ! 🎉"
