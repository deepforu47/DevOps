print ("\n Lets Play with Dictionary: ")
#Lets make a phone book:

#Define an empty dictionary
ages = {}

#Add few names to the dictionary
ages['Sam'] = 87
ages['Vik'] = 28
ages['Vishu'] = 54
ages['ND'] = 45
ages['Bunti'] = 37

# Display current Dictionary
print("*** Current Dictionary is :\t", ages)

#Use IN operator to check if specifid key is there in Dictionary. Syntax will be of this form:
#" if <value> in <dictionary> "
#this will returns TRUE, if the dictionary has key-name in it
#but returns FALSE if it doesn't. for key, value in ages.items():

if "Sam" in ages:
    print ("\nSam is in the dictionary. He is", \
ages['Sam'], "years old")

else:
    print ("\nSam is not in the dictionary")

#Use the function keys() -
#This function returns a list of all the names of the keys.
#E.g.
print ("\nThe following guys are in the dictionary:\t", \
ages.keys())

#You could use this "keys" function to put all the key names in a list:
keys = ages.keys()

#You can also get a list of all the values in a dictionary.
#You use the values() function:
print ("People are aged the following:\t", \
ages.values())

#Now put all values i.e. ages associated with each guy in a list:
values = ages.values()

#You can sort lists, with the sorted() function. It will sort all values in a list. alphabetically, numerically, etc...
#You can't sort dictionaries -they are in no particular order
print ("\nUnsorted Keys:\t", keys)
print ("Sorted Keys for Dictionary:\t", sorted(keys))

print ("\nUnsorted Values:\t", values)
print ("Sorted Values for Dictionary:\t", sorted(values))

#You can find the number of entries with the len() function:
print ("\nThe dictionary has", \
len(ages), "entries in it")


