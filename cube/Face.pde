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
    // now the next thing to do is to creep a little in on the cube in 3d space and project it back into 2d space
    stroke(255);
    strokeWeight(5);
    fill(255);
    beginShape();
    
    for (int i = 0; i < corners.length; i++) {
      vertex(cornerX[corners[i]], cornerY[corners[i]]);
    }
    
    endShape();
    
    noStroke();
    fill(faceColor);
    beginShape();
    
    float avgX = 0.0;
    float avgY = 0.0;
    
    for (int i = 0; i < corners.length; i++) {
      avgX += cornerX[corners[i]];
      avgY += cornerY[corners[i]];
    }
    
    avgX /= corners.length;
    avgY /= corners.length;
    
    for (int i = 0; i < corners.length; i++) {
      vertex(cornerX[corners[i]] * (1 - padding) + avgX * padding, cornerY[corners[i]] * (1 - padding) + avgY * padding);
    }
    
    endShape(CLOSE);
  }
}
