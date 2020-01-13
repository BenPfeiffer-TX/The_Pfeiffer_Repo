# This file holds simple utility functions that are called
# in both the main executable as well as the encoding function file

def zerobuffer(string):
        #Instead of making an if statement for every special character,
        #this function is used to add zeros to the beginning of characters when their
        #binary value is less than 8 bits
        while len(string)<8:
                string = '0' + string
        return string

# Filewrite is simple used to save lines in the main executable file:
# this function creates a new .txt file
# containing the original input, as well as the encoded output
def filewrite(name,userinput,encodedoutput):
        file = open(name,"w")
        file.write("Original input:\n" + userinput)
        file.write("\nEncoded output:\n" + encodedoutput)
        file.close()
