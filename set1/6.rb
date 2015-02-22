# a file has been base64 encoded after being encrypted with a repeating-key
# xor cipher. read the file and find the key.

def hex_to_ascii(hex_string)
    [hex_string].pack('H*')
end

def string_to_hex(string)
    string.bytes.map { |b| sprintf("%02X",b) }.join
end

def char_to_hex(char)
    char.unpack('H*').first
end

def xor_hex_strings(hex1, hex2)
    "%02x" % (hex1.to_i(16) ^ hex2.to_i(16))
end

def crypt_xor(text, key)
    result = []
    text.split('').each_with_index do |c, i|
        result << xor_hex_strings(char_to_hex(c), char_to_hex(key[i % key.length]))
    end
    result.join
end

def read_file(file)
    File.read(file).strip
end

def decode_base64(string)
    string.unpack('m').first
end

def string_to_bin(string)
    string.unpack('B*').first
end

def xor_strings(string1, string2)
    string_to_bin(string1).to_i(2) ^ string_to_bin(string2).to_i(2)
end

def hamming_distance(string1, string2)
    (xor_strings(string1, string2)).to_s(2).count('1')
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
        # 32-126 is printable
        c = c.downcase
        if (c.ord <= 'z'.ord && c.ord >= 'a'.ord)
            score = score + 15
        elsif '_ .,?!-$%()&\'";:'.include? c
            score = score + 3
        else
            score = score - 100
        end
    end
    return score
end

def break_block(text)
    results = []
    keyspace = (0..255).map {|n| n.chr}

    keyspace.each do |char|
        hex = decrypt_xor(char_to_hex(text), char_to_hex(char))
        ascii = hex_to_ascii(hex)
        results << {:ascii => ascii, :key => char, :score => score_string(ascii)}
    end

    sorted = results.sort_by { |hash| hash[:score] }
    sorted = sorted.reverse
    sorted[0][:key]
end

def guess_key_length(text)
    distances = {}
    # for each possible keysize
    (2..40).each do |keysize|
        # if the keysize is bigger than half the text, don't bother
        if text.length > keysize * 2
            distance = 0
            unpack_string = "a#{keysize}" * (text.length / keysize)
            blocks = text.unpack(unpack_string)
            # for each block of length keysize
            (1..blocks.length - 1).each do |index|
                # add the distance between current block and previous block
                distance = distance + (hamming_distance(blocks[index - 1], blocks[index]))# / keysize) it actually seems to work better without this
            end
            distances[keysize] = distance
        end
    end
    # sort so smallest distances are first
    sorted = distances.sort_by{|key, value| value}
    # return shortest 4 distances along with their keylength
    sorted[0, 4]
end

def text_to_blocks(key_size, text)
    unpack_string = "a#{key_size}" * (text.length / key_size)
    text_blocks = text.unpack(unpack_string)
    transposed_blocks = []
    (1..key_size).each do |key_position|
        transposed_block = ''
        text_blocks.each do |block|
            transposed_block = transposed_block + block[key_position - 1]
        end
        transposed_blocks << transposed_block
    end
    transposed_blocks
end

def break_xor_blocks(blocks)
    key = ''
    blocks.each do |block|
        key = key + break_block(block.strip)
    end
    key
end

# Read the file and get the bytes
xord_file = decode_base64(read_file('6.txt'))

# Get the most likely key length based on edit distance
guesses = guess_key_length(xord_file)
best_guess = guesses.first[0]

# Break the ciphertext into blocks of keysize.length and transpose
crypt_blocks = text_to_blocks(best_guess, xord_file)

# Figure out the most likely key
key = break_xor_blocks(crypt_blocks)
print "[+] Best guess for key:\n#{key}\n\n"

# Un-xor with the keyphrase
plaintext = hex_to_ascii(crypt_xor(xord_file, key))
print "[+] Recovered plaintext:\n#{plaintext}\n\n"

