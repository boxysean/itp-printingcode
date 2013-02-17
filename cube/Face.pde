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
      return -1;
    } else {
      return 1;
    }
  }
  
  void draw() {
    beginShape();
    fill(faceColor);
    
    for (int i = 0; i < corners.length; i++) {
      vertex(cornerX[corners[i]], cornerY[corners[i]]);
    }
    
    endShape(CLOSE);
  }
}
