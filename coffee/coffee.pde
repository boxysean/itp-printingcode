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
  } 
  while (diff > 1.5);
}

void setup() {
  size(1200, 1200);

  RG.init(this);

  findGoodNoiseSeed();

  smooth();
  //  noLoop();
}

Cup cup = null;

void draw() {
  long time = System.currentTimeMillis();
  //  beginRecord(PDF, "manyLaptops" + time + ".pdf");
  background(#FFFFFF);

  pushMatrix();
  translate(width/2, height/2);

  if (frameCount % 100 == 1) {
    if (random(2) < 1) {
      cup = new Mug(random(250, 350), random(200, 300));
    } 
    else {
      cup = new TeaCup(random(250, 350), random(150, 200));
    }
  }

  cup.draw();
  
  popMatrix();

  //  endRecord();

  //  save("manyLaptops" + time + ".tif");
}

