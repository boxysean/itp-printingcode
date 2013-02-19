class Face implements Comparable<Face> {
  int[] corners;
  int faceColor;
  
  Face(int[] corners, int faceColor) {
    this.corners = corners;
    this.faceColor = faceColor;
  } 
  
  int compareTo(Face f) {
    float thisminZ = 1e9;
    
    for (int i = 0; i < corners.length; i++) {
      thisminZ = min(thisminZ, cornerZ[corners[i]]);
    }
    
    float thatminZ = 1e9;
    
    for (int i = 0; i < corners.length; i++) {
      thatminZ = min(thatminZ, cornerZ[f.corners[i]]);
    }
    
    if (abs(thisminZ - thatminZ) < 1e-7) {
      return 0;
    } else if (thisminZ < thatminZ) {
      return 1;
    } else {
      return -1;
    }
  }
  
  void draw() {
    draw(faceColor);
  }
  
  void draw(int faceColor) {
    // setup the drawing
    stroke(255);
    strokeWeight(1);
    strokeCap(SQUARE);
//    noStroke();
    fill(255);
    
    // setup the avging of the face
    
    float avgX = 0.0;
    float avgY = 0.0;
    
    for (int i = 0; i < corners.length; i++) {
      avgX += cornerX[corners[i]];
      avgY += cornerY[corners[i]];
    }
    
    avgX /= corners.length;
    avgY /= corners.length;
    
    // draw the outside (white) face
    
    beginShape();
    
    for (int i = 0; i < corners.length; i++) {
      vertex(cornerX[corners[i]], cornerY[corners[i]]);
    }
    
    endShape(CLOSE);
    
    // setup the inside face
    
    noStroke();
    fill(faceColor);
    beginShape();
    
    // draw the inside (coloured) face
    
    for (int i = 0; i < corners.length; i++) {
      vertex(cornerX[corners[i]] * (1 - padding) + avgX * padding, cornerY[corners[i]] * (1 - padding) + avgY * padding);
    }
    
    endShape(CLOSE);
  }
}
