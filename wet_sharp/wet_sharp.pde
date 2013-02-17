import processing.pdf.*;

int rows = 12;
int waves = 6;

int waveSize = 25;

int padding = 40;
int thickness = 2;

boolean border = true;
int borderThickness = 5;

// wave y offset
int cy = 10;

void setup() {
  size((padding*2) + waveSize * waves, (padding*2) + waveSize * rows);
  println("width " + width + " height " + height + " ratio " + ((float) width / height));

  beginRecord(PDF, "wet_sharp.pdf"); 

  background(255);

  // // This code makes the basic triangle wave:
  //  beginShape();
  //  vertex(100, 100);
  //  vertex(150, 150);
  //  vertex(200, 100);
  //  vertex(250, 150);
  //  vertex(300, 100);
  //  endShape();

  pushMatrix();

  translate(padding, padding);

  // ** Draw the border **

  if (border) {
    strokeWeight(borderThickness);
    rect(0, 0, width-(2*padding), height-(2*padding));
  }

  strokeWeight(thickness);
  
  fill(255);
  
  int bby = rows * waveSize;
  
//  fill(255, 0, 0);
//  rect (-10, bby-10, 20, 20);
//  fill(255);

  for (int r = 0; r < rows; r++) {
    float curve = (waveSize/3) * ((float) r / (rows-1));
    
    float offset = random(waveSize);
    offset = waveSize/2;
    
    pushMatrix();
    
    int trans = waveSize * r - (waveSize/2);
    
    translate(0, trans);
    
    beginShape();
   
    for (int c = 0; c < waves; c++) {
      float co = c * waveSize; 
      
      vertex(co, waveSize-cy);
      bezierVertex(co+curve, waveSize-cy, co+(waveSize/2), waveSize/2-cy, co+(waveSize/2), waveSize/2-cy);
      bezierVertex(co+(waveSize/2), waveSize/2-cy, co+waveSize-curve, waveSize-cy, co+waveSize, waveSize-cy);

//      bezierVertex(co, 0, co+(waveSize/2)-curve, waveSize/2, co+(waveSize/2), waveSize/2);
//      bezierVertex(co+(waveSize/2)+curve, waveSize/2, co+waveSize, 0, co+waveSize, 0);
    }
    
    float lco = (waves-1) * waveSize;
    
    // this one just goes down to the next row...
//    vertex(lco+waveSize, waveSize-cy);
//    vertex(lco+waveSize, 2*waveSize-cy-3);
//    vertex(0, 2*waveSize-cy-3);
//    vertex(0, waveSize-cy);
    
    // this one goes down to the bottom
    vertex(lco+waveSize, waveSize-cy);
    vertex(lco+waveSize, (rows-r)*waveSize + waveSize/2);
    vertex(0, (rows-r)*waveSize + waveSize/2);
    vertex(0, waveSize-cy);
    
    endShape();
    
    popMatrix();
  }

  popMatrix();

  pushMatrix();

  translate(padding, padding);

  if (border) {
    strokeWeight(borderThickness);
    
//    rect(0, 10, width-(2*padding), height-(2*padding));
    
    noFill();
    
//    beginShape();
//    vertex(0, 0);
//    vertex(0, rows * waveSize + borderPadding);
//    vertex(waves * waveSize, rows * waveSize + borderPadding);
//    vertex(waves * waveSize, 0);
//    endShape();
  }

  popMatrix();

  // // This code makes the basic wavey wave:
  //  beginShape();
  //  vertex(100, 100);
  //  bezierVertex(100, 100, 150, 200, 200, 100);
  //  vertex(200, 100);
  //  bezierVertex(200, 100, 250, 150, 300, 100);
  //  endShape();
  
  noLoop();
  
  endRecord();
}

