namespace :availability do
  task generate: :environment do
    Availability.where('start_time < ?', Time.current).left_outer_joins(:appointment).where(appointments: { id: nil }).destroy_all

    Nurse.all.each do |nurse|
      next unless nurse.availabilities.where('start_time > ?', Time.current).count < 5

      (1..7).each do |day|
        Availability.create!(
          nurse: nurse,
          start_time: Time.current + day.days + 9.hours,
          is_booked: false
        )
      end
    end
  end
end
