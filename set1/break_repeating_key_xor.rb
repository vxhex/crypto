# a file has been base64 encoded after being encrypted with a repeating-key
# xor cipher. read the file and find the key.

def hex_to_ascii(hex_string)
    [hex_string].pack('H*')
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
    return sorted[0, 4]
end

# read the file and convert to decode contents
xord_file = decode_base64(read_file('xord_file.txt'))
#distance = hamming_distance('this is a test', 'wokka wokka!!!')
#guess_key_length('testa testb testc testd teste testf')
# using hamming distance to guess a key size
print guess_key_length(xord_file)
#print crypt_xor(text, 'ICE')
