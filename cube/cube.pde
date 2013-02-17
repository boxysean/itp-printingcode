import java.util.*;

float a1;
float a2;
float a3;

float a1s, a2s, a3s;

float dphi[] = { PI/3, PI/3, PI/3, PI/3, 2*PI/3, 2*PI/3, 2*PI/3, 2*PI/3 };
float dtheta[] = { 0, PI/2, PI, 3*PI/2, 0, PI/2, PI, 3*PI/2 };
float r = 100;

float padding = 0.2;

boolean pause = false;

int colors[] = new int[] { color(255, 0, 0),
                           color(0, 255, 0),
                           color(0, 0, 255),
                           color(255, 0, 255),
                           color(255, 255, 0),
                           color(0, 255, 255),
                           color(0, 0, 0),
                           color(255, 255, 255) };

float cornerX[] = new float[8];
float cornerY[] = new float[8];
float cornerZ[] = new float[8];

Face faces[] = new Face[6];

int facesIdx[][] = {
  { 0, 1, 2, 3 },
  { 4, 5, 6, 7 },
  { 0, 1, 5, 4 },
  { 1, 2, 6, 5 },
  { 2, 3, 7, 6 },
  { 3, 0, 4, 7 },
};

void setup() {
//  size(400, 400, P3D);
  size(400, 400);
  
  a1 = random(2 * PI);
//  a2 = random(2 * PI);
  a3 = random(2 * PI);
  
  a1s = random(0.01, 0.05);
  a2s = random(0.01, 0.05);
  a3s = random(0.01, 0.05);
  
  for (int i = 0; i < faces.length; i++) {
    faces[i] = new Face(facesIdx[i], colors[i]);
  }
  
  smooth();
  textFont(createFont("DroidSerif", 54));
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

void computeCorner(int idx) {
  float x = r * cos(dtheta[idx]) * sin(dphi[idx]);
  float y = r * sin(dtheta[idx]) * sin(dphi[idx]);
  float z = r * cos(dphi[idx]);
  
  float[] p = { x, y, z };
  
  rotate(p, a1, a2, a3);
  
  cornerX[idx] = p[0];
  cornerY[idx] = p[1];
  cornerZ[idx] = p[2];
}

void draw() {
  background(255);
  
  float cx = width / 2.0;
  float cy = height / 2.0;

  for (int i = 0; i < dphi.length; i++) {
    computeCorner(i);
  }
  
  Arrays.sort(faces);
  
  pushMatrix();

  translate(cx, cy);
  
  for (int i = 0; i < faces.length; i++) {
    faces[i].draw();
  }
    
  popMatrix();
  
  if (!pause) {
    a1 += a1s;
//    a2 += a2s;
    a3 += a3s;
  }
  
  fill(0);
  
  text("boxysean", cx-120, cy + r + 45);
}

void keyPressed() {
  pause = !pause;
}

