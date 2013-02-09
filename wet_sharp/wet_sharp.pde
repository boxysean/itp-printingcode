int rows = 20;
int waves = 6;

int waveSize = 25;

int padding = 50;
int thickness = 2;

boolean border = true;
int borderPadding = 4;
int borderThickness = 5;

void setup() {
  size((padding*2) + waveSize * waves, (padding*2) + waveSize * rows + borderPadding);

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
    rect(0, waveSize/4, width-(2*padding), height-(2*padding));
  }

  strokeWeight(thickness);
  
  fill(255);

  for (int r = 0; r < rows; r++) {
    float curve = (waveSize/3) * ((float) r / (rows-1));
    
    float offset = random(waveSize);
    offset = waveSize/2;
    
    pushMatrix();
    
    translate(0, waveSize * r - (waveSize/2));
    
    beginShape();
    
    for (int c = 0; c < waves; c++) {
      float co = c * waveSize; 
      
      vertex(co, waveSize);
      bezierVertex(co+curve, waveSize, co+(waveSize/2), waveSize/2, co+(waveSize/2), waveSize/2);
      bezierVertex(co+(waveSize/2), waveSize/2, co+waveSize-curve, waveSize, co+waveSize, waveSize);


//      bezierVertex(co, 0, co+(waveSize/2)-curve, waveSize/2, co+(waveSize/2), waveSize/2);
//      bezierVertex(co+(waveSize/2)+curve, waveSize/2, co+waveSize, 0, co+waveSize, 0);
    }
    
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
}

