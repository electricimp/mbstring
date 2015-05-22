# mbstring

Author: Aron Steg

**mbstring** implements a multibyte string class that can read, write and manipulate [UTF-8](http://en.wikipedia.org/wiki/UTF-8) strings.

**To add this library to your project, add** `#require "mbstring.class.nut:1.0.0"` **to the top of your device code**

The class supports the following operations:

- *foreach()* &ndash; Loops over each multibyte character (delivered as a series of strings).
- *len()* &ndash; Returns the number of multibyte characters not the byte length.
- *slice()* &ndash; Returns a sub-mbstring.
- *find()* &ndash; Searches an mbstring for the first occurence of another string or mbstring.
- *tostring()* &ndash; Converts the mbstring back to a UTF-8 string.
- *tointeger()* &ndash; Converts the mbstring back to a UTF-8 string and then converts that into an integer.
- *tofloat()* &ndash; Converts the mbstring back to a UTF-8 string and then converts that into a float.

## Class Usage Example

```
local fr = mbstring("123«€àâäèéêëîïôœùûüÿçÀÂÄÈÉÊËÎÏÔŒÙÛÜŸ»")
foreach (x in fr.slice(1, 4)) 
{
    server.log("Char: " + x)
}

server.log("Find: " + fr.find("ëîïôœ"))
server.log("Euro: " + fr[4])

```
