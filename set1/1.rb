
def hex_to_base64(hex_string)
    [[hex_string].pack('H*')].pack('m0')
end

#print hex_to_base64('49276d206b696c6c696e6720796f757220627261696e206c696b65206120706f69736f6e6f7573206d757368726f6f6d')
print hex_to_base64(ARGV[0])
