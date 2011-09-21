"""A series of classes that contain different regular expressions for
different string patterns. They all inherit from REBase, it itself a
basis for searching"""

import re

""" A class that serves as the basis for the REx classes. It contains
an initializer (usually for the unique patterns), a search and match
method that is similar to the re methods"""
class REBase:
    
    """ An initialiser that takes in the unique regex pattern"""
    def __init__(self, stringRead):
        self.pattern = stringRead
    
    """A simple method that takes in a string to be matched, and
    returns the result from the re module search"""
    def search(self, line):
        return re.search(self.pattern, line)
    
    """Another method that takes in a string to be matched, and
    returns the result from the re module search. This is unique
    in that it searches with the \A anchor, that is essentially 
    the search() equivalent to match()"""
    def match(self, line):
        return re.search("\A" + self.pattern, line)

""" A class that simply contains the pattern to match the string
of b's consecutively"""
class RE1(REBase):
    def __init__(self):
        REBase.__init__(self, 'b+$')

"""A class that contains a pattern to identify empty or Pythonistic
comments"""
class RE2(REBase):
    def __init__(self):
        REBase.__init__(self, '^#.*|^[ \f\n\r\v]+#+.*|^[ \f\n\r\v]+$|^$')
    
"""A class that contains a string regex pattern for the identification
of phone numbers."""
class RE3(REBase):
    def __init__(self):
        REBase.__init__(self, '\(([2-9]\d\d)\)\s*(\d\d\d)-(\d\d\d\d)')
    
"""A class that contains the matching of a name pattern with the format
Xy A. Jo(B, b)(B, b)etc...."""
class RE4(REBase):
    def __init__(self):
        REBase.__init__(self, '([A-Z][a-z]+)'\
                        +'\s+([A-Z]).+\s+'\
                        +'([A-Z](\w|\w\w)[A-Z]\w*|[A-Z][a-z]+|'
                        +'[A-Z](\w|\w\w|\w\w\w)|[A-Z])')
        
"""A class that sorts through a University-esque database for three groupings:
        last name, first name and email."""
class RE5(REBase):
    def __init__(self):
        REBase.__init__(self, '(?P<family>[A-Z][a-z]*)\s*'
                        +'(?P<given>[A-Z][a-z]*).*'
                        +'\s(?P<email>\S+@+\S+).*')
        