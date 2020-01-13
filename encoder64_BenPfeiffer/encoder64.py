# This file contains:
# the encoding function that converts ascii characters to base64

# This dictionary is used to match the encoded binary values to their ascii output chars
base64 = {0:'A',1:'B',2:'C',3:'D',4:'E',5:'F',6:'G',7:'H',8:'I',9:'J',10:'K',11:'L',12:'M',13:'N',14:'O',15:'P',
16:'Q',17:'R',18:'S',19:'T',20:'U',21:'V',22:'W',23:'X',24:'Y',25:'Z',26:'a',27:'b',28:'c',29:'d',30:'e',31:'f',
32:'g',33:'h',34:'i',35:'j',36:'k',37:'l',38:'m',39:'n',40:'o',41:'p',42:'q',43:'r',44:'s',45:'t',46:'u',47:'v',
48:'w',49:'x',50:'y',51:'z',52:'0',53:'1',54:'2',55:'3',56:'4',57:'5',58:'6',59:'7',60:'8',61:'9',62:'+',63:'/'}

# We import the function zerobuffer from our utility file
from encode_util import zerobuffer



def encode64(userinput):
        # Simple error handling in case the user passes in a different data type
        # (in theory this will never happen since any readable file will be interpreted as a string of ascii)
        if type(userinput)!=str:
                raise Exception('TypeError: encode64() was passed something other than a string')
        
        # We instantiate our buffer variable and encoded output
        # Buffer is instantiated as a string, since we have to pull 6 bits at a time
        # Encodedoutput is instantiated as a list so that we can be memory efficient;
        # instead of creating a new value for encodedoutput each time we add to it,
        # we can just append to the list and then join it together to make a string at the end
        buffer = ""
        encodedoutput = []

        # We iterate through our userinput string, converting each ascii char to its binary value
        for charinput in userinput:
                # Zerobuffer is used to add zeros to the beginning of an ascii string
                # (when the length is less than 8)
                # The '[2:]' applied to the bin(ord(charinput))
                # is so that we don't retain the '0b' from converting an ascii to binary
                buffer += zerobuffer(bin(ord(charinput))[2:])

                #When our buffer has more than 6 bits, we can encode values to base64
                while len(buffer)>6:
                        # Encode the first 6 bits and then append to our output variable
                        encodedoutput.append( base64[ int(buffer[:6],2) ] )
                        # Remove encoded bits from buffer
                        buffer = buffer[6:]

        # When we are done encoding our file, there will most likely be leftover bits
        # in the buffer. To retain this information, we append zeros to the buffer until
        # there are enough bits to encode it
        while len(buffer)<6:
                buffer+='0'
        encodedoutput.append( base64[ int(buffer,2) ] )
        
        # After encoding, we turn our list into a string
        encodedoutput = ''.join(encodedoutput)
    
        # Depending on the length of our output, we may or may not add padding
        if len(encodedoutput)%4==2:
            encodedoutput+="=="
        elif len(encodedoutput)%4==3:
            encodedoutput+="="
                 
        return(encodedoutput)        
