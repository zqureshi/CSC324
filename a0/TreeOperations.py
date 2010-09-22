# CSC 324 Fall 2010 - Assignment 0
#
# Zeeshan Qureshi
# zeeshan.qureshi@utoronto.ca

# Import all List function
from List import *
from ListOperations import *

# Import all Tree function
from Tree import *

def treeToNestedLists(t):
  if (t.left == None and t.right == None):
    return cons(t.label, None)
  else:
    return cons(t.label, 
        cons(treeToNestedLists(t.left), 
          cons(treeToNestedLists(t.right), None)))

def treeToString(t):
  if(t.left == None and t.right == None):
    return t.label
  else:
    return t.label + '(' + treeToString(t.left) + ',' + treeToString(t.right) + ')'
