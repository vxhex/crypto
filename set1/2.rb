
def xor(h1, h2)
    (h1.to_i(16) ^ h2.to_i(16)).to_s(16)
end

#print xor('1c0111001f010100061a024b53535009181c', '686974207468652062756c6c277320657965')
print xor(ARGV[0], ARGV[1])
