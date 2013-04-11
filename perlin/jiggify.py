#!/bin/python 
import sys
import pysvg.parser
import noise
import random

svg = pysvg.parser.parse(sys.argv[1])

def jiggify(e):
  if e._elementName == "path":
    d = e.get_d()
    newD = "m"
    split = d.split()[1:-1]
    cx, cy = [float(i) for i in split[0].split(",")]
    newD += " %d,%d" % (cx, cy)
    absolute = False
# we gonna figure out the boundaries, then we gonna perlin noise it per shape

    keepTrack = []
    printIt = False

    minX, minY, maxX, maxY = 100000, 100000, -100000, -100000
    for xy in split[1:]:
      if absolute:
        printIt = True
        ax, ay = [float(i) for i in xy.split(",")]
        x = ax - cx
        y = ay - cy
        cx = ax
        cy = ay
        absolute = False
      elif xy == "l":
        continue
      elif xy == "L":
        absolute = True
      else:
        x, y = [float(i) for i in xy.split(",")]
        cx += x
        cy += y
      minX = min(minX, cx)
      minY = min(minY, cy)
      maxX = max(maxX, cx)
      maxY = max(maxY, cy)
      keepTrack.append((cx, cy))

    if printIt:
      print keepTrack

    cx, cy = [float(i) for i in split[0].split(",")]

    for xy in split[1:]:
      if absolute:
        ax, ay = [float(i) for i in xy.split(",")]
        x = ax - cx
        y = ay - cy
        cx = ax
        cy = ay
        absolute = False
      elif xy == "l":
        continue
      elif xy == "L":
        absolute = True
      else:
        x, y = [float(i) for i in xy.split(",")]
        cx += x
        cy += y

      px = cx-minX / (maxX-minX) * (3.0 / 4.0)
      py = cy-minY / (maxY-minY) * (3.0 / 4.0)

      px1o = random.random()/4
      py1o = random.random()/4
      px2o = random.random()/4
      py2o = random.random()/4

      # this is a little weird, right? offsetting the x and y by the same z?
      newD += " %f,%f" % (x + noise.pnoise2(px + px1o, py + py1o) * (3.0 / 4.0), y + noise.pnoise2(px + px2o, py + py2o) * (3.0 / 4.0))
      print "x,y (%d,%d) cx,cy (%.2f,%.2f) noise %.2f" % (x, y, cx, cy, noise.pnoise2(px, py))
    newD += " z"
    e.set_d(newD)
    return

  for i in e.getAllElements():
    try:
      jiggify(i)
    except AttributeError:
      pass

jiggify(svg)

svg.save("output.svg")
