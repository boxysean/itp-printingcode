int rows = 10;
int waves = 6;

int waveSize = 50;

int padding = 50;
int thickness = 5;

boolean border = true;
int borderPadding = 25;
int borderThickness = 5;

void setup() {

  size((padding*2) + waveSize * waves, (padding*2) + waveSize * rows + borderPadding);

  background(255);

  strokeWeight(thickness);

  noFill();

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

  for (int r = 0; r < rows; r++) {
    float curve = 25 * ((float) r / (rows-1));
    
    float offset = random(waveSize);
    offset = waveSize/2;
    
    for (int c = 0; c < waves+1; c++) {
      pushMatrix();
      translate((waveSize*c) - offset, waveSize * r);
      
      beginShape();
      vertex(0, 0);
      bezierVertex(0, 0, (waveSize/2)-curve, waveSize/2, waveSize/2, waveSize/2);
      bezierVertex((waveSize/2)+curve, waveSize/2, waveSize, 0, waveSize, 0);
      endShape();

      popMatrix();
    }
  }

  popMatrix();

  fill(255);
  noStroke();
  
  rect(0, 0, padding, height);
  rect(width-padding, 0, padding, height);
  
  noFill();
  stroke(0);

  pushMatrix();

  translate(padding, padding);

  if (border) {
    strokeWeight(borderThickness);
    
    rect(0, 10, width-(2*padding), height-(2*padding));
    
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
}

