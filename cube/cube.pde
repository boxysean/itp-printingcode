float a1;
float a2;
float a3;

float a1s, a2s, a3s;

void setup() {
//  size(400, 400, P3D);
  size(400, 400);
  
  a1 = random(2 * PI);
//  a2 = random(2 * PI);
  a3 = random(2 * PI);
  
  a1s = random(0.01, 0.05);
  a3s = random(0.01, 0.05);
  
//  noLoop();
}

// from http://en.wikipedia.org/wiki/Matrix_rotation
void rotate(float[] p, float phi, float theta, float psi) {
  float x = p[0];
  float y = p[1];
  float z = p[2];  
  
  p[0] = x * cos(theta) * cos(psi) - y * (cos(phi) * sin(psi) + sin(phi) * sin(theta) * cos(psi)) + z * (sin(phi) * sin(psi) + cos(phi) * sin(theta) * cos(psi));
  p[1] = x * cos(theta) * sin(psi) + y * (cos(phi) * cos(psi) + sin(phi) * sin(theta) * sin(psi)) - z * (sin(phi) * cos(psi) + cos(phi) * sin(theta) * sin(psi));
  p[2] = -x * sin(theta) + y * sin(phi) * cos(theta) + z * cos(phi) * cos(theta);
}


float dphi[] = { PI/4, PI/4, PI/4, PI/4, 3*PI/4, 3*PI/4, 3*PI/4, 3*PI/4 };
float dtheta[] = { 0, PI/2, PI, 3*PI/2, 0, PI/2, PI, 3*PI/2 };
float r = 100;

void drawCorner(int idx) {
  float x = r * cos(dtheta[idx]) * sin(dphi[idx]);
  float y = r * sin(dtheta[idx]) * sin(dphi[idx]);
  float z = r * cos(dphi[idx]);
  
  float[] p = { x, y, z };
  
  rotate(p, a1, a2, a3);
  
  vertex(p[0], p[1]);
}

void draw() {  
  background(255);
  
  float cx = width / 2.0;
  float cy = height / 2.0;
  
  int colors[] = new int[] { color(255, 0, 0),
                             color(0, 255, 0),
                             color(0, 0, 255),
                             color(255, 0, 255),
                             color(255, 255, 0),
                             color(0, 255, 255),
                             color(0, 0, 0),
                             color(255, 255, 255) };
  
  
  pushMatrix();
  translate(cx, cy);

  int order[] = { 0, 1, 2, 3, 0, 4, 5, 6, 7, 4, 5, 1, 2, 6, 7, 3 };
  
  for (int i = 0; i < order.length; i++) {
    drawCorner(order[i]);
  }
  
  int faces[][] = {
    { 0, 1, 2, 3 },
    { 4, 5, 6, 7 },
    { 0, 1, 5, 4 },
    { 1, 2, 6, 5 },
    { 2, 3, 7, 6 },
    { 3, 0, 4, 7 },
  };
  
  for (int i = 0; i < faces.length; i++) {
    fill(colors[i]);
    noStroke();
    beginShape();
    for (int j = 0; j < faces[i].length; j++) {
      drawCorner(faces[i][j]);
    }
    endShape();
  }
    
  popMatrix();
  
//  a1 += 0.01;
//  a2 += 0.02;
//  a3 += 0.04;

  a1 += a1s;
  a3 += a3s;

//  float x = r * cos(a1) * sin(a2);
//  float y = r * sin(a1) * sin(a2);
//  float z = r * cos(a2);
//  
//  // rigid pt
//  float ox = r * cos(a1) * sin(a2 + 3*PI/2);
//  float oy = r * sin(a1) * sin(a2 + 3*PI/2);
//  float oz = r * cos(a2+3*PI/2);
//  
//  // reflected of xyz around (0, 0)
//  float px = r * cos(PI+a1) * sin(PI-a2);
//  float py = r * sin(PI+a1) * sin(PI-a2);
//  float pz = r * cos(PI-a2);
//  
//  // rigid 3rd point on cube
//  float qx = r * cos(a1) * sin(a2+PI/2);
//  float qy = r * sin(a1) * sin(a2+PI/2);
//  float qz = r * cos(a2+PI/2);
//  
//  // rigid 4rd point on cube!!!
//  float rx = r * cos(PI-a1) * sin(a2+PI/2);
//  float ry = r * sin(PI-a1) * sin(a2+PI/2);
//  float rz = r * cos(a2+PI/2);
//  
//  a1 += 0.01;
//  a2 += 0.02;
//
//  pushMatrix();
//  translate(cx, cy);
//
//  pushMatrix();
//  translate(x, y, z);
//  fill(255, 0, 0);
//  box(10);
//  popMatrix();
//  
//  pushMatrix();
//  translate(ox, oy, oz);
//  fill(0, 255, 0);
//  box(10);
//  popMatrix();
//  
//  pushMatrix();
//  translate(px, py, pz);
//  fill(0, 0, 255);
//  box(10);
//  popMatrix();
//  
//  pushMatrix();
//  translate(qx, qy, qz);
//  fill(255, 0, 255);
//  box(10);
//  popMatrix();
//  
//  pushMatrix();
//  translate(rx, ry, rz);
//  fill(255, 255, 0);
//  box(10);
//  popMatrix();
//  
//  popMatrix();
}
