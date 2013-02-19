import java.util.*;

import processing.pdf.PGraphicsPDF;

import toxi.color.*;
import toxi.color.theory.*;
import toxi.util.datatypes.*;

int run = 0;
float sideA = 312*PI/1024; // approx equal...
float sideB = PI-sideA;

float dphi[] = { sideA, sideA, sideA, sideA, sideB, sideB, sideB, sideB };

float dtheta[] = { 0, PI/2, PI, 3*PI/2, 0, PI/2, PI, 3*PI/2 };

float R = 200;

float padding = 0.15;

boolean pause = false;

int colors[] = new int[] { 
  color(255, 0, 0), 
  color(0, 255, 0), 
  color(0, 0, 255), 
  color(255, 0, 255), 
  color(255, 255, 0), 
  color(0, 255, 255), 
  color(0, 0, 0), 
  color(255, 255, 255)
};

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
  { 3, 0, 4, 7 }
};

ColorList list;

void setup() {
  size(500, 500);
  smooth();

  // color theory
  ArrayList<ColorTheoryStrategy> strategies = ColorTheoryRegistry.getRegisteredStrategies();

//  ColorTheoryStrategy strategy = strategies.get((int) random(strategies.size()));
  ColorTheoryStrategy strategy = new MonochromeTheoryStrategy();

  TColor col = ColorRange.WARM.getColor();

  list = ColorList.createUsingStrategy(strategy, col);
  
  println("Strategy: " + strategy.getName());

  for (int i = 0; i < faces.length; i++) {
    faces[i] = new Face(facesIdx[i], list.get(i % list.size()).toARGB());
  }
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

void computeCorner(int idx, float r, float mod) {
  float x = r * cos(mod + dtheta[idx]) * sin(dphi[idx]);
  float y = r * sin(mod + dtheta[idx]) * sin(dphi[idx]);
  float z = r * cos(dphi[idx]);

  float[] p = { x, y, z };

  rotate(p, (float) mouseModX / width * PI, 0, (float) mouseModY / height * PI);

  cornerX[idx] = p[0];
  cornerY[idx] = p[1];
  cornerZ[idx] = p[2];
}

void draw() {
  if (drawAsPdf) {
    String fileName = "cubez_" + System.currentTimeMillis() + ".pdf";
    beginRecord(PDF, "cubez_" + System.currentTimeMillis() + ".pdf");
    println("Printing as " + fileName);
  }
  
  background(255);

  pushMatrix();

  translate(width/2.0, height/2.0);

  for (int i = 0; i < dphi.length; i++) {
    computeCorner(i, R, PI/3);
  }

  Arrays.sort(faces);

  for (int i = 0; i < faces.length; i++) {
    faces[i].draw();
  }

  for (int i = 0; i < dphi.length; i++) {
    computeCorner(i, R/2.0, 2*PI/3);
  }

  Arrays.sort(faces);

  for (int i = 0; i < faces.length; i++) {
    faces[i].draw(list.get((2*list.size() + (list.size() - i - 1)) % list.size()).toARGB());
  }

  popMatrix();
  
  if (drawAsPdf) {
    drawAsPdf = false;
    endRecord();
  }
}

int lastMouseX;
int lastMouseY;

int mouseModX = 0;
int mouseModY = 0;

void mouseDragged() {
  if (lastMouseX > -10000) {
    mouseModX += mouseX - lastMouseX;
    mouseModY += mouseY - lastMouseY;
  }
  
  lastMouseX = mouseX;
  lastMouseY = mouseY;
}

void mouseReleased() {
  lastMouseX = -10000;
  lastMouseY = -10000;
}

boolean drawAsPdf = false;

void keyPressed() {
  if (keyCode == ' ') {
    drawAsPdf = true;
  }
}
