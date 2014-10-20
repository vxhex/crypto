# finds a single character xor key for a hex string ciphertext

def hex_to_ascii(hex_string)
    [hex_string].pack('H*')
end

def hex_to_base64(hex_string)
    [[hex_string].pack('H*')].pack('m0')
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

def score_strings(strings)
    results = []
    strings.each do |string|
        results << {:score => score_string(string), :ascii => string}
    end
    results.sort_by {|hash| hash[:score]}
end

def crack_xor(text)
    best = {:score => 0, :key => '', :ascii => ''}
    keyspace = ('a'..'z').to_a + ('A'..'Z').to_a + ('0'..'9').to_a
    keyspace.each do |x|
        hex = decrypt_xor(text, char_to_hex(x))
        ascii = hex_to_ascii(hex)
        score = score_string(ascii)
        if score > best[:score]
            best[:score] = score
            best[:key] = x
            best[:ascii] = ascii
        end
    end
    print "Best guess with score of #{best[:score]} and key of '#{best[:key]}':\n#{best[:ascii]}\n"
end

#crack_xor('3204474b1c030a1f4c184b1e1b54')
crack_xor('1b37373331363f78151b7f2b783431333d78397828372d363c78373e783a393b3736')
