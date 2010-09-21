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

def map(l, fn):
  if(l == None):
    return
  else:
    return cons(fn(first(l)), map(rest(l), fn))

def consAll(obj, l):
  return map(l, lambda x: cons(obj, x))
