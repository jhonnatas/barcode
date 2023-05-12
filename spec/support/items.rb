FactoryBot.define do
  factory :item do
    numero { Faker::Number.number(digits: 6) }
    descricao { Faker::Lorem.paragraph(sentence_count: 5) }
  end
end