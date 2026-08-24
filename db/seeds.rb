# House of Bijou — internal test seed data (MVP stage)

setting = Setting.first || Setting.new
setting.pin = "2500" if setting.pin_digest.blank?
setting.text_scale ||= 18
setting.high_contrast ||= false
setting.disguise = "Weather"
setting.chat_timer_minutes = 60 if setting.chat_timer_minutes.nil?
setting.pseudonym = "Zawadi"
setting.avatar_color = "#c29765"
setting.save!

{
  "Mumbi" => { color: "#c29765", relationship: "Chosen family", position: 1, phone: "+254700111222" },
  "Ash" =>    { color: "#a9bd7e", relationship: "Neighbour",     position: 2, phone: "+254700333444" },
  "Njeri" =>  { color: "#8a9a5b", relationship: "Sister",        position: 3, phone: "+254700555666" },
  "Riri" =>   { color: "#d9b98a", relationship: "Chosen family", position: 4, phone: "+254700777888" }
}.each do |name, attrs|
  contact = Contact.find_or_create_by!(name: name)
  contact.update!(attrs)
end

if Conversation.count.zero?
  mumbi = Conversation.create!(title: "Mumbi", color: "#c29765", position: 1)
  ash = Conversation.create!(title: "Ash", color: "#a9bd7e", position: 2)
  circle = Conversation.create!(title: "Circle check-ins", color: "#8a9a5b", position: 3)

  Message.create!(conversation: mumbi, sender: "them", body: "Hey, are you okay? Saw the news about your area.", created_at: 3.hours.ago)
  Message.create!(conversation: mumbi, sender: "you", body: "I'm safe. Staying in tonight.", created_at: 2.hours.ago)
  Message.create!(conversation: mumbi, sender: "them", body: "Good. Ping me when you check in tomorrow ❤️", created_at: 90.minutes.ago)
  Message.create!(conversation: ash, sender: "them", body: "Water is back on my side. You?", created_at: 5.hours.ago)
  Message.create!(conversation: circle, sender: "them", body: "Circle check-in: everyone safe this week?", created_at: 26.hours.ago)
  Message.create!(conversation: circle, sender: "you", body: "Safe and home.", created_at: 25.hours.ago)
end

rent = AidRequest.find_or_create_by!(title: "Rent gap after my hours were cut") do |r|
  r.target_amount = 4_000
  r.deadline = 6.days.from_now.to_date
  r.status = "open"
end

Pledge.find_or_create_by!(aid_request: rent, helper_name: "Ash") do |p|
  p.kind = "given"; p.amount = 2_000; p.note = "Lent 2,000 · repaid 15 Aug"
end
Pledge.find_or_create_by!(aid_request: rent, helper_name: "Njeri") do |p|
  p.kind = "pledge"; p.amount = 500; p.note = "Will cover it on payday"
end

stock = AidRequest.find_or_create_by!(title: "Stock top-up for my market stall") do |r|
  r.target_amount = 2_500
  r.deadline = 12.days.from_now.to_date
  r.status = "open"
end
Pledge.find_or_create_by!(aid_request: stock, helper_name: "Riri") do |p|
  p.kind = "given"; p.amount = 1_000; p.note = "Restock the vegetables first"
end

VoteProposal.find_or_create_by!(title: "A quiet waiting room at the centre for people in crisis") do |v|
  v.supports_count = 18
end

if Story.count.zero?
  Story.create!(author: "Riri", body: "I showed up for the food and left with three aunties who check if I got home safe. Two years later I'm the one cooking.", created_at: 2.days.ago)
  Story.create!(author: "Njeri", body: "My chosen family taught me that blood doesn't get to define who belongs. Sunday dinners did.", created_at: 5.days.ago)
end

puts "Seeded: #{Setting.count} setting(s), #{Contact.count} contacts, #{Conversation.count} conversations, #{Message.count} messages, #{AidRequest.count} aid request(s), #{Story.count} stories, #{VoteProposal.count} proposal(s)."
