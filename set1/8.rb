# a file has several hex strings, one of which was encrypted with aes-128-ecb.
# detect which line has been encrypted.

# Read the file and get the lines
File.readlines('8.txt').each do |line|
    # break into 16 byte blocks
    # 1 byte is 2 hex digits, 16 bytes is 32 digits
    score = 0
    blocks = line.strip.scan(/.{32}/)
    blocks.each do |block|
        occurrences = blocks.count(block)
        if occurrences > 1
            score = score + occurrences
            blocks.delete(block)
        end
    end
    print "#{score}: #{line}" if score > 0
end

