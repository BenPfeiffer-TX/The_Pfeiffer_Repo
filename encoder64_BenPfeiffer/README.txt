REQUIREMENTS TO RUN:
--------------------
This encoding script requires any version of Python2 or Python3 to execute, 
as well as having the Python Standard Library already installed. 
Additionally, write access will be required for the user/program in the directory that the executable is located.


HOW TO USE:
-----------
	(Windows or MacOSX)
	Double-click on 'encoder_exec.py'
	A Windows CMD will open up, running the script
	(Linux or MacOSX)
	In a terminal, type "python# encoder_exec.py", where python# is the installed version of Python
	A Python terminal will start within your terminal, running the script
When the program starts, it will prompt you for either an arbitrary string, or the name of an input file.
To have the script encode a file, simply type the name of the file (e.g. "example.txt" or "testinput.log")
(NOTE: the input file needs to exist within the directory that the executable is located)
If the entered filename doesn't exist in the working directory, or an arbitrary string was entered,
the script will encode the user input.

After encoding the user input, the script will display the encoded result in the terminal.
The user will then be prompted to either press enter, or provide an output filename (in the format 'output.txt', for example).
The output file will contain both the entered user input, as well as the base64 encoded output.
If a name is provided:
	The script will create a file with the exact filename provided by the user.
	If a file already exists in the working directory with the same filename, it will be overwritten.
If no name is provided:
	The script will create an output file with the naming convention 'encoded_output#.txt',
	where # is the number of times the script has been ran and allowed to auto-name the output.
	[For example, the first run will result in 'encoded_output1.txt'
	The second time the script is ran (assuming nothing is done to 'encoded_output1.txt' or the working directory is changed),
	the output file will be titled 'encoded_output2.txt']


LIMITATIONS, CONCESSIONS:
-------------------------
The largest limitation of this script is that it will interpret all input as a string of ascii characters.
The script has no ability to recognize binary, hexadecimal, or any other text format that isnt UTF-8.
This modularity in the script was left out for two reasons:
1) I didn't think it would be appropriate to invest more than a few hours into this programming assignment,
and 
2) The code to recognize the data type of input would essentially have to be a special case implementation for every concern.
Having the script handle binary or UTF-32 input would require either conditional statements all over the encoding function,
or a separate encoding function for each data type inputted. I don't consider the former to be efficient programming,
and recognizing binary or other text encoding formats is enough of a fringe-case scenario that they require an explicit justification to be implemented.

I chose to write this program in Python for a couple reasons:
1) It gave me another opportunity to learn more about Python, and to practice writing more "pythonic" code
2) Python is a much more portable language than C. 
I didn't have to be concerned about whether the script would run on any operating system if I chose Python over C.
