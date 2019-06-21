alphabet = ('а'..'я').to_a
vowels = ["а", "е", "и", "о", "у", "ы", "э", "ю", "я"]
vowels_hash = {}

vowels.each { |v| vowels_hash[v] = alphabet.index(v) }
vowels_hash.each { |vowel, index| puts "#{vowel} - #{index}" }
