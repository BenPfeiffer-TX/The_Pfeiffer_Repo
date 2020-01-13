# Ben Pfeiffer, 17Dec2019
# Base64 (or other base) encoder, project for job application at -------
# Goal: Develop a program that receives information from the user,
# and creates an output .txt file containing the input encoded in base64

# Potential limitations: current implementation wont recognize binary or other
# bases for input; it'll treat everything as an ascii char when encoding


# This is the main executable for this program, so here we will take care of
# user I/O, and creating the output file

# Packages necessary for this program:
# glob is used for file input as well as seeing named files in directory
# encode64 is the base64 encoding function (this can be switched out for
#   any other form of encoding)
# filewrite is a function that writes the user input and encoded output to a .txt
import glob
from encoder64 import encode64
from encode_util import filewrite

# We take in either a string from the user, or a filename to encode
print("Welcome to Ben Pfeiffer's base64 encoder!")
userinput = input("Either enter an arbitrary string, or the name of an input file (including type extension): ")

inputfile = glob.glob(userinput)
# Check to see if input is a filename
if len(inputfile)>0:
    #User is passing in an input file
    file = open(inputfile[0],"r")
    encodedoutput = encode64(file.read())
else:
    #User is passing in a string, encode directly
    encodedoutput = encode64(userinput)
    
# Encoding is complete, now we print the output and create an output .txt
print("Your encoded data is: " + encodedoutput)
temp = input("If you want to control the name of the output file, enter that here (excluding the .txt)\nOtherwise, press enter:")

# Check to see if user provided an output filename
if len(temp)==0:
    #No filename is given, so we call it "encoded_output#.txt"
    look = glob.glob("encoded_output*")
    if len(look)==0:
        #Girst output created, we name it encoded_output1
        filewrite('encoded_output1.txt',userinput,encodedoutput)
    else:
        #More than one auto-named output has been created, so we add 1 to end of name
        filewrite('encoded_output'+str(len(look) + 1)+'.txt',userinput,encodedoutput)
else:
    #User specifies a file output name
    filewrite(temp+'.txt',userinput,encodedoutput)
