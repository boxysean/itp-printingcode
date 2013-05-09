class TeaCup extends Cup {

  public TeaCup(float w, float h) {
    super(w, h);
    float x1 = random(w/4.0, w/2.0); // top right
    float x2 = random(w/8.0, x1-w/4.0); // bottom right

    float y1 = random(h/6.0, h/3.0); // top point in the bezier
    float y2 = random(2*h/3.0, 5*h/6.0); // bottom point in the bezier

    // "depth" of the 2.5ness
    float d = random(30, 80);
    
    body = new RShape();
    body.addMoveTo(x1, -h/2.0);
    body.addBezierTo(x1, -h/2.0 + y1, x2, h/2.0 - y2, x2, h/2.0);
    body.addBezierTo(x2, h/2.0 + d, -x2, h/2.0 + d, -x2, h/2.0);
    body.addBezierTo(-x2, h/2.0 + y1, -x2, h/2.0 - y2, -x1, -h/2.0);
    body.addBezierTo(-x1, -h/2.0 - d, x1, -h/2.0 - d, x1, -h/2.0);

    RPath rCurvePath = new RPath(x1, -h/2.0);
    rCurvePath.addBezierTo(x1, -h/2.0 + y1, x2, h/2.0 - y2, x2, h/2.0);
    rCurve = new RShape(rCurvePath);
    rCurvePts.add(new PVector(x1, -h/2.0));
    rCurvePts.add(new PVector(x1, -h/2.0 + y1));
    rCurvePts.add(new PVector(x2, h/2.0 - y2));
    rCurvePts.add(new PVector(x2, h/2.0));

    RPath lCurvePath = new RPath(-x1, -h/2.0);
    lCurvePath.addBezierTo(-x1, -h/2.0 + y1, -x2, h/2.0 - y2, -x2, h/2.0);
    lCurve = new RShape(lCurvePath);
    lCurvePts.add(new PVector(-x1, -h/2.0));
    lCurvePts.add(new PVector(-x1, -h/2.0 + y1));
    lCurvePts.add(new PVector(-x2, h/2.0 - y2));
    lCurvePts.add(new PVector(-x2, h/2.0));

    RPath tCurvePath = new RPath(x1, -h/2.0);
    tCurvePath.addBezierTo(x1, -h/2.0 + d, -x1, -h/2.0 + d, -x1, -h/2.0);
    tCurve = new RShape(tCurvePath);

    RPath ttCurvePath = new RPath(x1, -h/2.0);
    ttCurvePath.addBezierTo(x1, -h/2.0 - d, -x1, -h/2.0 - d, -x1, -h/2.0);
    ttCurve = new RShape(ttCurvePath);

    RPath bCurvePath = new RPath(x2, h/2.0);
    bCurvePath.addBezierTo(x2, h/2.0 + d, -x2, h/2.0 + d, -x2, h/2.0);
    bCurve = new RShape(bCurvePath);

    float hCurveTr = random(0.1, 0.3);
    RPoint hCurveTs = lCurve.getPoint(hCurveTr);
    RPoint hCurveTe = rCurve.getPoint(hCurveTr);
    RPath hCurveTPath = new RPath(hCurveTs.x, hCurveTs.y);
    hCurveTPath.addBezierTo(hCurveTs.x, hCurveTs.y + d, hCurveTe.x, hCurveTe.y + d, hCurveTe.x, hCurveTe.y);
    hCurveT = new RShape(hCurveTPath);

    float hCurveBr = random(max(0.5, hCurveTr+.3), 0.8);
    RPoint hCurveBs = lCurvePath.getPoint(hCurveBr);
    RPoint hCurveBe = rCurvePath.getPoint(hCurveBr);
    RPath hCurveBPath = new RPath(hCurveBs.x, hCurveBs.y);
    hCurveBPath.addBezierTo(hCurveBs.x, hCurveBs.y + d, hCurveBe.x, hCurveBe.y + d, hCurveBe.x, hCurveBe.y);
    hCurveB = new RShape(hCurveBPath);
  }
  
  public RShape getSlice(float r) {
    ArrayList<PVector> srcCurve;
    
    if (r < 0.5) {
      srcCurve = lCurvePts;
      r = (0.5 - r) * 2;
    } else {
      srcCurve = rCurvePts;
      r = (r - 0.5) * 2;
    }

    RPath curvePath = new RPath(srcCurve.get(0).x * r, srcCurve.get(0).y);
    curvePath.addBezierTo(srcCurve.get(1).x * r, srcCurve.get(1).y, srcCurve.get(2).x * r, srcCurve.get(2).y, srcCurve.get(3).x * r, srcCurve.get(3).y);
    return new RShape(curvePath); 
  }

}

