# xor encrypts a hex string using a multi-character key

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

text = "Burning 'em, if you ain't quick and nimble
I go crazy when I hear a cymbal"
print crypt_xor(text, 'ICE')
