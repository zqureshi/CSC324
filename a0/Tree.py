# CSC 324 Fall 2010 - Assignment 0
#
# Zeeshan Qureshi
# zeeshan.qureshi@utoronto.ca

from List import *
from ListOperations import *

class Tree:
  # Precondition: label a string ; left and right both None or both Trees.
  def __init__(self, label, left, right):
    self.label = label
    self.left = left
    self.right = right

