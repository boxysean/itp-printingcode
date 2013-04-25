//void drawPolygon(float... c) {
//  beginShape();
//  
//  for (int i = 0; i < c.length; i += 2) {
//    vertex(c[i], c[i+1]);
//  }
//  
//  endShape(CLOSE);
//}

boolean closePolygon = true;

void closePolygon(boolean b) {
  closePolygon = b;
}

void drawPolygon(float... c) {
  RShape p = new RShape();

  p.addMoveTo(c[0], c[1]);

  int end = c.length+1;
  
  if (!closePolygon) {
    end--;
  }

  for (int i = 2; i < end; i += 2) {
    p.addLineTo(c[i%c.length], c[(i+1)%c.length]);
  }

  RG.setPolygonizer(RG.UNIFORMLENGTH);
  RG.setPolygonizerLength(10);
  RPoint[] points = p.getPoints();

  beginShape();
  float px = random(0.1, 0.3);
  float py = random(0.1, 0.3);
  float amp = 10;
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x + amp * noise(px);
    float y = points[i].y + amp * noise(py);
    px += 0.03;
    py += 0.03;
    vertex(x, y);
  }
  endShape();
}

