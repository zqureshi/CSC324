# CSC 324 Fall 2010 - Assignment 0
#
# Zeeshan Qureshi
# zeeshan.qureshi@utoronto.ca

from List import *

class isSubsequence:
  def call(self, l1, l2):
    if (l1 == None):
      return True
    elif (l2 == None):
      return False
    elif (first(l1) == first(l2)):
      return self.call(rest(l1), rest(l2))
    else:
      return self.call(l1, rest(l2))

class map:
  def call(self, fn, l):
    if (l == None):
      return
    else:
      return cons(fn.call(first(l)), self.call(fn, rest(l)))

class Conser:
  def __init__(self, obj):
    self.obj = obj

  def call(self, l):
    return cons(self.obj, l)

class consAll:
  def call(self, obj, l):
    return map().call(Conser(obj), l)

class append:
  def call(self, l1, l2):
    if (l1 == None):
      return l2
    else:
      return cons(first(l1), self.call(rest(l1), l2))

class subsequences:
  def call(self, l):
    if(l == None):
      return cons(None, None)
    else:
      return append().call(self.call(rest(l)), consAll().call(first(l), self.call(rest(l))))
