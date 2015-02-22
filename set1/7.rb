# a file has been base64 encoded after being encrypted with aes-128-ecb.
# the key is "YELLOW SUBMARINE".

require 'openssl'

# Read the file and get the bytes
ciphertext = File.read('7.txt').strip.unpack('m').first

aes = OpenSSL::Cipher.new('AES-128-ECB')
aes.key = 'YELLOW SUBMARINE'
#aes.padding = 0
aes.decrypt
puts aes.update(ciphertext) + aes.final

