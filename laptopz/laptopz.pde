import geomerative.*;
import processing.pdf.*;

import pbox2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


// TRY:
// - rounding corners of the screen

// JIGGLE:
// - keyboard
// - overdrawing / underdrawing keyboard crosshatches

// TODO:
// - prevent certain angles

PBox2D box2d;

ArrayList<Laptop> laptops = new ArrayList<Laptop>();
ArrayList<Boundary> boundaries = new ArrayList<Boundary>();

void setup() {
  size(1000, 800);

  RG.init(this);

  smooth();
//  noLoop();
  
  
  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();

  // Turn on collision listening!
  box2d.listenForCollisions();
  
  for (int i = 0; i < 2; i++) {
    makeOneLaptop();
  }
  
  boundaries.add(new Boundary(0, 0, 10, height));
  boundaries.add(new Boundary(width-10, 0, 10, height));
  boundaries.add(new Boundary(0, height-10, width, 10));
}

void drawManyLaptops() {
  for (int i = 0; i < 700; i++) {
    float x = random(-width/2.0, width/2.0);
    float y = random(-height/2.0, height/2.0);
    float angle = random(0, 2*PI);
    float w = random(100, 200);
    float h = random(80, w-10);
    float r = random(-PI/6, PI/6);

    float keyboardPaddingPercent = random(0.03, 0.10);
    float keyboardSizePercent = random(0.4, 0.6);

    float keyboardThickness = random(5, 10);
    float keyboardRows = (int) random(3, 6);
    float keyboardColumns = (int) random(8, 15);
    float trackpadPaddingPercent = random(0.05, 0.1);

    float screenPaddingPercent = random(0.05, 0.15);

    Laptop laptop = new Laptop(x, y, angle, w, h, r, 
    keyboardPaddingPercent, keyboardSizePercent, keyboardThickness, 
    keyboardRows, keyboardColumns, trackpadPaddingPercent, screenPaddingPercent, false);
    
    laptop.draw();
  }
}

void makeOneLaptop() {
  float x = random(0, width);
  float y = 0;
  float angle = PI/3.0;
  float w = 80;
  float h = 60;
//  float w = random(300, 400);
//  float h = random(200, w-10);
  float r = 0;

  float keyboardPaddingPercent = random(0.03, 0.10);
  float keyboardSizePercent = random(0.4, 0.6);

  float keyboardThickness = random(5, 10);
  float keyboardRows = (int) random(3, 6);
  float keyboardColumns = (int) random(8, 15);
  float trackpadPaddingPercent = random(0.05, 0.1);

  float screenPaddingPercent = random(0.05, 0.15);

  laptops.add(new Laptop(x, y, angle, w, h, r, 
  keyboardPaddingPercent, keyboardSizePercent, keyboardThickness, 
  keyboardRows, keyboardColumns, trackpadPaddingPercent, screenPaddingPercent, false));
}

void drawRotatingLaptop() {
  float x = 0;
  float y = 0;
  float angle = PI/4.0;
  float w = 300;
  float h = 200;
  float r = 0;

  float keyboardPaddingPercent = 0.05;
  float keyboardSizePercent = 0.5;

  float keyboardThickness = 5;
  float keyboardRows = (int) 4;
  float keyboardColumns = (int) 12;
  float trackpadPaddingPercent = 0.05;

  float screenPaddingPercent = 0.1;

  Laptop laptop = new Laptop(x, y, angle, w, h, r, 
  keyboardPaddingPercent, keyboardSizePercent, keyboardThickness, 
  keyboardRows, keyboardColumns, trackpadPaddingPercent, screenPaddingPercent, true);
  
  laptop.draw();
}

void draw() {
//  beginRecord(PDF, "laptopz.pdf");
  background(#FFFFFF);

  box2d.step();

//  drawOneLaptop();
//  drawRotatingLaptop();
//  drawManyLaptops();

  for (Laptop laptop : laptops) {
    laptop.draw();
  }

  for (Boundary boundary : boundaries) {
    boundary.display();
  }

//  endRecord();
}

// Collision event functions!
void beginContact(Contact cp) {
}


// Objects stop touching each other
void endContact(Contact cp) {
}

