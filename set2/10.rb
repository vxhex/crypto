require 'openssl'

class ManualCbc
end

# split text into blocks and pad
# blocks.unshift(iv)
# block0 = iv
# (block1..blockn).each
#  blocki = crypt(blocki-1 ^ blocki)
# end
