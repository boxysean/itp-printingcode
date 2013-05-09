import processing.pdf.*;

import geomerative.*;

// TODO:
// - prevent certain angles

void findGoodNoiseSeed() {
  float diff = 0;

  do {
    noiseSeed((int) random(1 << 20));
    
    float amp = 20;
    
    float before = amp * noise(0.99);
    float after = amp * noise(0.0);
    
    diff = abs(before - after);
//    System.out.printf("before %.2f after %.2f\n", amp * noise(0.99), amp * noise(0.00));
    
//    if (diff > 1.5) {
//      System.out.printf("diffff %.2f\n", diff);
//    }
  } while (diff > 1.5);
}

void setup() {
  size(1200, 1200);

  RG.init(this);
  
  findGoodNoiseSeed();

  smooth();
//  noLoop();
}

//void drawPolygon(float... c) {
//  beginShape();
//  
//  for (int i = 0; i < c.length; i += 2) {
//    vertex(c[i], c[i+1]);
//  }
//  
//  endShape(CLOSE);
//}

float minX, maxX, minY, maxY;

void setLaptopBoundaries(float minXX, float maxXX, float minYY, float maxYY) {
  minX = minXX;
  maxX = maxXX;
  minY = minYY;
  maxY = maxYY;
}

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
  RG.setPolygonizerLength(4);
  RPoint[] points = p.getPoints();

  beginShape();
  float px = 0.0;
  float py = 0.0;
  float amp = 25;
  
  boolean over = false;
  
  for (int i = 0; i < points.length; i++) {
    float x = points[i].x + amp * noise(px);
    float y = points[i].y + amp * noise(py);
    px += 0.03;
    py += 0.03;
    
    if (px >= 1.0) {
      px -= 1.0;
    }
    
    if (py >= 1.0) {
      py -= 1.0;
    }
    vertex(x, y);
  }
  
  endShape();
}

void drawLaptop(float x, float y, float angle, float w, float h, float r, 
float keyboardPaddingPercent, float keyboardSizePercent, float keyboardThickness, 
float keyboardRows, float keyboardColumns, float trackpadPaddingPercent, float screenPaddingPercent) {
  pushMatrix();
  translate(width / 2, height / 2);
  translate(x, y);
  rotate(r);
  
  angle = frameCount / 100.0;

  float modAngle = angle % (2*PI);
  
  float xx = h * cos(angle);
  float yy = h * sin(angle);
  
  float minX = -w/2.0;
  float maxX = xx+w/2.0;
  float minY = -h;
  float maxY = yy;

  setLaptopBoundaries(minX, maxX, minY, maxY);

  // keyboard base
  //  float keyboardThickness = 10;

  if (0 < modAngle && modAngle <= PI) {
    drawPolygon(-w/2.0, 0, 
    -w/2.0, keyboardThickness, 
    xx-w/2.0, yy + keyboardThickness, 
    xx-w/2.0, yy);

    drawPolygon(xx+w/2.0, yy, 
    xx+w/2.0, yy + keyboardThickness, 
    w/2.0, keyboardThickness, 
    w/2.0, 0);

    drawPolygon(xx-w/2.0, yy, 
    xx-w/2.0, yy + keyboardThickness, 
    xx+w/2.0, yy + keyboardThickness, 
    xx+w/2.0, yy);
  } 
  else {
    drawPolygon(xx-w/2.0, yy, 
    xx-w/2.0, yy + keyboardThickness, 
    xx+w/2.0, yy + keyboardThickness, 
    xx+w/2.0, yy);

    drawPolygon(-w/2.0, 0, 
    -w/2.0, keyboardThickness, 
    xx-w/2.0, yy + keyboardThickness, 
    xx-w/2.0, yy);

    drawPolygon(xx+w/2.0, yy, 
    xx+w/2.0, yy + keyboardThickness, 
    w/2.0, keyboardThickness, 
    w/2.0, 0);
  }

  drawPolygon(-w/2.0, 0, 
  xx-w/2.0, yy, 
  xx+w/2.0, yy, 
  w/2.0, 0);

  // keyboard crosshatch
  //  float keyboardPaddingPercent = 0.05;
  //  float keyboardSizePercent = 0.5;
  //  float keyboardRows = 4;
  //  float keyboardColumns = 10;

  float keytlx = -w/2.0 + (h * keyboardPaddingPercent) * cos(angle) + (w * keyboardPaddingPercent);
  float keytrx = w/2.0 + (h * keyboardPaddingPercent) * cos(angle) - (w * keyboardPaddingPercent);
  float keyblx = -w/2.0 + (h * keyboardSizePercent) * cos(angle) + (w * keyboardPaddingPercent);
  float keybrx = w/2.0 + (h * keyboardSizePercent) * cos(angle) - (w * keyboardPaddingPercent);

  float keyty = h * keyboardPaddingPercent * sin(angle);
  float keyby = h * keyboardSizePercent * sin(angle);  

  drawPolygon(keytlx, keyty, 
  keytrx, keyty, 
  keybrx, keyby, 
  keyblx, keyby);
  
  for (int i = 1; i < keyboardRows; i++) {
    float keyrowy = (keyby - keyty) * ((float) i / keyboardRows) + keyty;
    float keyrowlx = (keyblx - keytlx) * ((float) i / keyboardRows) + keytlx;
    float keyrowrx = (keybrx - keytrx) * ((float) i / keyboardRows) + keytrx;
//    line(keyrowlx, keyrowy, keyrowrx, keyrowy);
    closePolygon(false);
    drawPolygon(keyrowlx, keyrowy, keyrowrx, keyrowy);
    closePolygon(true);
  }

  for (int i = 1; i < keyboardColumns; i++) {
    float keycoltx = (keytrx - keytlx) * ((float) i / keyboardColumns) + keytlx;
    float keycolbx = (keybrx - keyblx) * ((float) i / keyboardColumns) + keyblx;
//    line(keycoltx, keyty, keycolbx, keyby);
    closePolygon(false);
    drawPolygon(keycoltx, keyty, keycolbx, keyby);
    closePolygon(true);
  }

  // trackpad
  //  float trackpadPaddingPercent = 0.05;
  float trackpadSizePercent = 1.0 - keyboardSizePercent;
  float trackpadSizeRatio = 1.0;

  float trackpadh = h * (trackpadSizePercent - 2 * trackpadPaddingPercent);
  float trackpadw = trackpadh * trackpadSizeRatio;
  float trackpadby = h * (1.0 - trackpadPaddingPercent) * sin(angle);
  float trackpadty = h * (1.0 - trackpadSizePercent + trackpadPaddingPercent * 2) * sin(angle);

  float trackpadtlx = h * (1.0 - trackpadSizePercent + trackpadPaddingPercent * 2) * cos(angle) - trackpadw/2.0;
  float trackpadtrx = h * (1.0 - trackpadSizePercent + trackpadPaddingPercent * 2) * cos(angle) + trackpadw/2.0;
  float trackpadblx = h * (1.0 - trackpadPaddingPercent) * cos(angle) - trackpadw/2.0;
  float trackpadbrx = h * (1.0 - trackpadPaddingPercent) * cos(angle) + trackpadw/2.0;

  drawPolygon(trackpadtlx, trackpadty, 
  trackpadtrx, trackpadty, 
  trackpadbrx, trackpadby, 
  trackpadblx, trackpadby);

  //  line(0, 0, cos(angle) * h, sin(angle) * h);
  //  line(cos(angle) * h / 2.0 - w/4.0, sin(angle) * h / 2.0, cos(angle) * h - w/4.0, sin(angle) * h);

  // screen
  fill(#FFFFFF);
  //  float screenPaddingPercent = 0.05;

  if (0 < modAngle && modAngle <= PI) {
    drawPolygon(-w/2.0, -h, w/2.0, -h, w/2.0, 0, -w/2.0, 0);
//    rect(-w/2.0, -h, w, h);
    drawPolygon(-w/2.0 * (1-screenPaddingPercent), -h * (1-screenPaddingPercent),
                w/2.0 * (1-screenPaddingPercent), -h * (1-screenPaddingPercent),
                w/2.0 * (1-screenPaddingPercent), -h * screenPaddingPercent,
                -w/2.0 * (1-screenPaddingPercent), -h * screenPaddingPercent);
//    rect(-w/2.0 * (1-screenPaddingPercent), -h * (1-screenPaddingPercent), w * (1-screenPaddingPercent), h * (1-2*screenPaddingPercent));
  } 
  else {
//    rect(-w/2.0, -h, w, h + keyboardThickness);
    drawPolygon(-w/2.0, -h, w/2.0, -h, w/2.0, keyboardThickness, -w/2.0, keyboardThickness);
  }

  popMatrix();
}

void drawManyLaptops() {
  for (int i = 0; i < 1000; i++) {
    float x = random(-width/2.0, width/2.0);
    float y = random(-height/2.0, height/2.0);
    
    float angle = 0;

    if ((int) random(3) == 0) {
      angle = random(7*PI/6.0, 11*PI/6.0);
    } else {
      angle = random(PI/6.0, 5*PI/6.0);
    }
    
    float w = random(50, 80);
    float h = random(w/2+5, w-10);
    float r = random(-PI/6, PI/6);

    float keyboardPaddingPercent = random(0.03, 0.10);
    float keyboardSizePercent = random(0.4, 0.6);

    float keyboardThickness = random(5, 10);
    float keyboardRows = (int) random(3, 6);
    float keyboardColumns = (int) random(8, 15);
    float trackpadPaddingPercent = random(0.05, 0.1);

    float screenPaddingPercent = random(0.05, 0.15);

    drawLaptop(x, y, angle, w, h, r, 
    keyboardPaddingPercent, keyboardSizePercent, keyboardThickness, 
    keyboardRows, keyboardColumns, trackpadPaddingPercent, screenPaddingPercent);
  }
}

  float x = 0;
  float y = 0;
  float angle = random(PI/6.0);
  float w = random(300, 400);
  float h = random(200, w-10);
  float r = 0;

  float keyboardPaddingPercent = random(0.03, 0.10);
  float keyboardSizePercent = random(0.4, 0.6);

  float keyboardThickness = random(5, 10);
  float keyboardRows = (int) random(3, 6);
  float keyboardColumns = (int) random(8, 15);
  float trackpadPaddingPercent = random(0.05, 0.1);

  float screenPaddingPercent = random(0.05, 0.15);



void drawOneLaptop() {
//  float x = 0;
//  float y = 0;
//  float angle = random(PI/6.0);
//  float w = random(300, 400);
//  float h = random(200, w-10);
//  float r = 0;
//
//  float keyboardPaddingPercent = random(0.03, 0.10);
//  float keyboardSizePercent = random(0.4, 0.6);
//
//  float keyboardThickness = random(5, 10);
//  float keyboardRows = (int) random(3, 6);
//  float keyboardColumns = (int) random(8, 15);
//  float trackpadPaddingPercent = random(0.05, 0.1);
//
//  float screenPaddingPercent = random(0.05, 0.15);
//
  drawLaptop(x, y, angle, w, h, r, 
  keyboardPaddingPercent, keyboardSizePercent, keyboardThickness, 
  keyboardRows, keyboardColumns, trackpadPaddingPercent, screenPaddingPercent);
}

void draw() {
  long time = System.currentTimeMillis();
//  beginRecord(PDF, "manyLaptops" + time + ".pdf");
  background(#FFFFFF);

  drawOneLaptop();
//  drawManyLaptops();
//  drawLaptopsAndCoffee();
  
  noFill();
  rect(0, 0, width, height);
  
  endRecord();
  
//  save("manyLaptops" + time + ".tif");
}

