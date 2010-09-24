# CSC 324 Fall 2010 - Assignment 0
#
# Zeeshan Qureshi
# zeeshan.qureshi@utoronto.ca

from List import *

def isSubsequence(l1, l2):
  if (l1 == None):
    return True
  elif (l2 == None):
    return False
  elif (first(l1) == first(l2)):
    return isSubsequence(rest(l1), rest(l2))
  else:
    return isSubsequence(l1, rest(l2))

def map(fn, l):
  if (l == None):
    return
  else:
    return cons(fn.call(first(l)), map(fn, rest(l)))

class Conser:
  def __init__(self, obj):
    self.obj = obj

  def call(self, l):
    return cons(self.obj, l)

def consAll( obj, l):
    return map(Conser(obj), l)

def append(l1, l2):
  if (l1 == None):
    return l2
  else:
    return cons(first(l1), append(rest(l1), l2))

def subsequences(l):
  if(l == None):
    return cons(None, None)
  else:
    return append(subsequences(rest(l)), consAll(first(l), subsequences(rest(l))))
