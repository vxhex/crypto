class Pkcs7
    # pad an individual block
    def self.pad_block(block, block_size)
        difference = block_size - block.length
        (1..difference).each do |count|
            block = block + difference.chr
        end
        block
    end

    # create a block of only padding
    def self.pad_empty_block(block_size)
        output = ''
        (1..block_size).each do |count|
            output = output + block_size.chr
        end
        output
    end

    # pad a string
    def self.pad(text, block_size)
        output = ''

        # if text is multiple blocks
        if text.length > block_size
            blocks = text.scan(/.{1,#{block_size}}/)
            if blocks.last.length == block_size
                blocks << pad_empty_block(block_size)
            else
                blocks[-1] = pad_block(blocks.last, block_size)
            end
            output = blocks.join
        end

        # if text is less than one block
        if text.length < block_size
            output = pad_block(text, block_size)
        end

        # if text is exactly one block
        if text.length == block_size
            blocks = [text]
            blocks << pad_empty_block(block_size)
            output = blocks.join
        end

        output
    end
end

print Pkcs7::pad('YELLOW SUBMARINE', 20)
