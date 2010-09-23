# CSC 324 Fall 2010 - Assignment 0
#
# Zeeshan Qureshi
# zeeshan.qureshi@utoronto.ca

# Import all List function
from List import *
from ListOperations import *

# Import all Tree function
from Tree import *

import sys

def treeToNestedLists(t):
  if (t.left == None and t.right == None):
    return cons(t.label, None)
  else:
    return cons(t.label, 
        cons(treeToNestedLists(t.left), 
          cons(treeToNestedLists(t.right), None)))

def nestedListsToTree(l):
  if (rest(l) == None):
    return Tree(first(l), None, None)
  else:
    return Tree(first(l), 
        nestedListsToTree(first(rest(l))),
        nestedListsToTree(first(rest(rest(l)))))

def treeToString(t):
  if(t.left == None and t.right == None):
    return t.label
  else:
    return t.label + '(' + treeToString(t.left) + ',' + treeToString(t.right) + ')'

def printCalls(t):
  if (t.left == None and t.right == None):
    print t.label
  else:
    printCalls(t.left)
    printCalls(t.right)
    print t.label + '  ==>  ' + treeToString(t)

def printNestedLists(l, indent=''):
  if (rest(l) == None):
    sys.stdout.write(indent + first(l))
  else:
    print indent + '(' + first(l)
    printNestedLists(first(rest(l)), indent + '  ')
    print
    printNestedLists(first(rest(rest(l))), indent + '  ')
    sys.stdout.write(')')

    # If at the outermost list, add an extra newline for pretty printing
    if(indent == ''):
      print
