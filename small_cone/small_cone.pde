import processing.pdf.*;

void Ellipse(float x, float y, float w, float h) {
  ellipse(x, y, w, h);
}

void Rect(float x, float y, float w, float h) {
  rect(x, y, w, h);
}

void Triangle(float x1, float y1, float x2, float y2, float x3, float y3) {
  triangle(x1, y1, x2, y2, x3, y3);
}

void drawCircle(float x, float y, float r, int iterations, boolean outline) {
  for (int i = 0; i < iterations; i++) {
    // via: http://stackoverflow.com/questions/5837572/generate-a-random-point-within-a-circle-uniformly
    
    float angle = random(0, 2*PI);
    float u = random(0, 1) + random(0, 1);
    
    float radius = 0;
    
    if (u > 1) {
      radius = (2-u) * r;
    } else {
      radius = u * r;
    }
    
    float r1 = floor(random(5, 10));
    
    float xx = floor(x + radius * cos(angle));
    float yy = floor(y + radius * sin(angle));
    
    if (yy < 300) {
      Ellipse(xx, yy, r1, r1);
    }
  }
  
  if (outline) {
    int oldStroke = g.strokeColor;
    stroke(255, 0, 0);
    Ellipse(x, y, r*2, r*2);
    stroke(oldStroke);
  }
}

void drawRectangle(float x, float y, float w, float h, int iterations, boolean outline) {
  for (int i = 0; i < iterations; i++) {
    float X = random(x, x+w);
    float Y = random(y, y+h);
    
    float r1 = random(2, 4);
    float r2 = random(0, 2*PI);
    
    pushMatrix();
    
    translate(X, Y);
    rotate(r2);
    
    Rect(-r1, -r1, 2*r1, 2*r1);
    
    popMatrix();
  }
  
  if (outline) {
    int oldStroke = g.strokeColor;
    stroke(255, 0, 0);
    Rect(x, y, w, h);
    stroke(oldStroke);
  }
}

// via http://www.java-gaming.org/index.php?topic=22590.0
boolean lineIntersection(double x1, double y1, double x2, double y2, double x3, double y3, double x4, double y4){
  // Return false if either of the lines have zero length
  if (x1 == x2 && y1 == y2 ||
        x3 == x4 && y3 == y4){
     return false;
  }
  // Fastest method, based on Franklin Antonio's "Faster Line Segment Intersection" topic "in Graphics Gems III" book (http://www.graphicsgems.org/)
  double ax = x2-x1;
  double ay = y2-y1;
  double bx = x3-x4;
  double by = y3-y4;
  double cx = x1-x3;
  double cy = y1-y3;

  double alphaNumerator = by*cx - bx*cy;
  double commonDenominator = ay*bx - ax*by;
  if (commonDenominator > 0){
     if (alphaNumerator < 0 || alphaNumerator > commonDenominator){
        return false;
     }
  }else if (commonDenominator < 0){
     if (alphaNumerator > 0 || alphaNumerator < commonDenominator){
        return false;
     }
  }
  double betaNumerator = ax*cy - ay*cx;
  if (commonDenominator > 0){
     if (betaNumerator < 0 || betaNumerator > commonDenominator){
        return false;
     }
  }else if (commonDenominator < 0){
     if (betaNumerator > 0 || betaNumerator < commonDenominator){
        return false;
     }
  }
  if (commonDenominator == 0){
     // This code wasn't in Franklin Antonio's method. It was added by Keith Woodward.
     // The lines are parallel.
     // Check if they're collinear.
     double y3LessY1 = y3-y1;
     double collinearityTestForP3 = x1*(y2-y3) + x2*(y3LessY1) + x3*(y1-y2);   // see http://mathworld.wolfram.com/Collinear.html
     // If p3 is collinear with p1 and p2 then p4 will also be collinear, since p1-p2 is parallel with p3-p4
     if (collinearityTestForP3 == 0){
        // The lines are collinear. Now check if they overlap.
        if (x1 >= x3 && x1 <= x4 || x1 <= x3 && x1 >= x4 ||
              x2 >= x3 && x2 <= x4 || x2 <= x3 && x2 >= x4 ||
              x3 >= x1 && x3 <= x2 || x3 <= x1 && x3 >= x2){
           if (y1 >= y3 && y1 <= y4 || y1 <= y3 && y1 >= y4 ||
                 y2 >= y3 && y2 <= y4 || y2 <= y3 && y2 >= y4 ||
                 y3 >= y1 && y3 <= y2 || y3 <= y1 && y3 >= y2){
              return true;
           }
        }
     }
     return false;
  }
  return true;
}
 
void drawTriangle(float x1, float y1, float x2, float y2, float x3, float y3, int iterations, boolean outline) {
  for (int i = 0; i < iterations; i++) {
    float a = random(0, 1);
    float b = random(0, 1);
    
    float px = a * (x2 - x1) + b * (x3 - x1);
    float py = a * (y2 - y1) + b * (y3 - y1);
    
    float Apx = x1 + px;
    float Apy = y1 + py;
    
    // a point is in a polygon iff a line intersecting the point (with any vector) intersects with the polygonal lines an odd number of times
    
    int intersections = 0;
  
    if (lineIntersection(Apx, Apy, -1, -2, x1, y1, x2, y2)) {
     intersections++;
    } 
  
    if (lineIntersection(Apx, Apy, -1, -2, x2, y2, x3, y3)) {
     intersections++;
    } 
  
    if (lineIntersection(Apx, Apy, -1, -2, x3, y3, x1, y1)) {
     intersections++;
    }
    
    // See: http://stackoverflow.com/a/240898
    if (intersections % 2 == 0) {
      // outside
      Apx = x1 + (x2 - x1) + (x3 - x1) - px;
      Apy = y1 + (y2 - y1) + (y3 - y1) - py;
      // now inside!
    }
    
    float r1 = random(3, 6);
    float r2 = random(2*PI);
    
    Triangle(Apx+r1*cos(r2), Apy+r1*sin(r2),
             Apx+r1*cos(r2+PI*2/3), Apy+r1*sin(r2+PI*2/3),
             Apx+r1*cos(r2+PI*4/3), Apy+r1*sin(r2+PI*4/3));
  }
  
  if (outline) {
    int oldStroke = g.strokeColor;
    stroke(255, 0, 0);
    Triangle(x1, y1, x2, y2, x3, y3);
    stroke(oldStroke);
  }
}

void setup() {
  background(255);
  
  smooth();

  int sc = 1;
  
  size(400*sc, 800*sc);
  
  noFill();
  fill(0);
  noStroke();
  
  boolean outline = false;
  
  beginRecord(PDF, "icecream.pdf"); 
  
  scale(sc, sc);
  
  drawCircle(215, 230, 140, 1000, outline);
  drawRectangle(85, 300, 260, 70, 400, outline);
  drawTriangle(110, 370, 320, 370, 215, 700, 800, outline);

  endRecord();

  noLoop();
}


