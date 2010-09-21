# CSC 324 Fall 2010 - Assignment 0
#
# Zeeshan Qureshi
# zeeshan.qureshi@utoronto.ca

class List:
  def __init__(self, first, rest):
    self.__first = first
    self.__rest = rest

  def __str__(self):
    if(rest(self) == None):
      return '(' + str(first(self)) + ')'
    else:
      return '(' + str(first(self)) + ', ' + str(rest(self)) + ')'

# Precondition: rest is a List or None.
def cons(first, rest): return List(first, rest)

# Precondition: l is a List.
def first(l): return l._List__first
def rest(l): return l._List__rest

# Like the Java version, don't access the List instance variables or 
# constructor directly in your solutions. But, similarly, you may access
# them for testing, possibly via added methods such as __str__, __cmp__.
# To complete the similarity, here is the corresponding usage example:
# l = cons(3, cons(2, cons(4, None)))
# print first(l)
# print rest(l)
