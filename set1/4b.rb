# reads a file of hex strings and figures out which one contains a single-character xor ciphertext
# displays top 5 results

def hex_to_ascii(hex_string)
    [hex_string].pack('H*')
end

def char_to_hex(char)
    char.unpack('H*').first
end

def xor_hex_strings(h1, h2)
    (h1.to_i(16) ^ h2.to_i(16)).to_s(16)
end

def decrypt_xor(ciphertext, key)
    length = ciphertext.length
    extended_key = key * length
    extended_key = extended_key[0..length-1]
    xor_hex_strings(ciphertext, extended_key)
end

def score_string(string)
    score = 0
    string.split('').each do |c|
        c = c.downcase
        if (c.ord <= 'z'.ord && c.ord >= 'a'.ord) || (c == ' ')
            score = score + 3
        end
        if '.,?!-$%()&\'";:'.include? c
            score = score + 1
        end
    end
    return score
end

results = []
best = {:score => 0, :key => '', :ascii => ''}
keyspace = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
File.readlines('4.txt').each do |line|
    text = line.strip
    keyspace.each do |x|
        hex = decrypt_xor(text, char_to_hex(x))
        ascii = hex_to_ascii(hex)
        results << {:ascii => ascii, :key => x, :text => text, :score => score_string(ascii)}
    end
end

sorted = results.sort_by { |hash| hash[:score] }
sorted = sorted.reverse
sorted[0..4].each do |hash|
    print "Best guess with score of #{hash[:score]} and key of '#{hash[:key]}':\n#{hash[:text]}\n#{hash[:ascii]}\n"
end

