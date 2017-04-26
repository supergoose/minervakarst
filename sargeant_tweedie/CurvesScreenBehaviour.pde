class CurvesScreenBehaviour implements ScreenBehaviour{
  
   Dot dots[];
   Dot dotsTiered[][];
   
   int tiers = 80;
   
   int stage = 0;
   float stageTimings[] = {4000, 500, 2000, 7000, 50000, 5000, 5000};
   float lastStageTime = 0;
   float lineHeight;
   
   int numPeaks = 15;
   float offset[];
   float targetOffset[];
   float minOffset = -200.0f;
   float maxOffset = 200.0f;
   int seed;
   float spinDrawAngle = 0.0f;
   
   CurvyLine[] curvylines;
  
   CurvesScreenBehaviour(Dot[] dots)
   {
      this.dots = dots;
      this.dotsTiered = new Dot[tiers][ceil((float)this.dots.length/(float)tiers)];
      
      //Seperate dots into lines from where they are
      //Get the highest dot
      
      lineHeight = height*2/tiers;
      int dotId = 0;
      for(int i = 0; i < tiers; i++)
      {
        for(int j = 0; j < ceil((float)this.dots.length/(float)tiers) && dotId < this.dots.length; j++)
        {
           int tier = i%tiers;
           float targetY = tier*lineHeight - height/2;
           
           float targetX = random(0,width);
           this.dots[dotId].setBehaviour(new CurvesDotBehaviour(this.dots[i].position, new PVector(targetX, targetY, 0)));
           
           this.dotsTiered[i][j] = dots[dotId];
           dotId++;
        }
        
        
      }
      lastStageTime = millis();
   }
   
   void update()
   {
      for(int i = 0; i < this.dots.length; i++)
       {
         this.dots[i].update();
       }
   }
   
   void draw()
   {
      switch(this.stage)
      {
        case 0:
          drawPoints();
          break;
        case 1:
          drawLines();
          break;
        case 2:
        //We need to make curvy lines but only when we call the drawcurves function
          createCurves();
          drawCurves(0.0f, false);
          break;
        case 3:
          drawCurves(0.0f, true);
          break;
        case 4:
          spinDrawCurves();
          break;
        case 5:
          spinDrawAngle = 0.0f;
          drawCurves(0.0f, false);
          break;
        case 6:
          drawLines();
          break;
          
      }
      
      if(millis()-lastStageTime > stageTimings[this.stage])
      {
        this.stage++;
        lastStageTime = millis();
        if(this.stage > this.stageTimings.length-1)this.stage = 0;
        
      }
   }
   
   void drawPoints()
   {
     strokeWeight(2);      
      beginShape(POINTS);
      int dotId = 0;
      for(int i = 0; i < tiers; i++)
      {
        
        for(int j = 0; j < this.dotsTiered[i].length && dotId < this.dots.length; j++)
        {
          vertex(this.dotsTiered[i][j].position.x, this.dotsTiered[i][j].position.y, this.dotsTiered[i][j].position.z);
          dotId++;
        }
        
      }
      endShape();
   }
   
   void drawLines()
   {
     strokeWeight(1);      
     stroke(100);
      beginShape(LINES);
      int dotId = 0;
      for(int i = 0; i < tiers; i++)
      {
        int tier = i%tiers;
        float targetY = tier*lineHeight - height/2;
        vertex(0, targetY, this.dotsTiered[i][0].position.z);
        vertex(width, targetY, this.dotsTiered[i][0].position.z);
        
      }
      endShape();
   }
   
   void createCurves()
   {  
      
      curvylines = new CurvyLine[tiers];
      float targetZ = this.dotsTiered[0][0].position.z;
      
      int ranSeed = floor(random(1, 11000));
      
      float xOffsets[] = new float[tiers*numPeaks];
      for(int i = 0; i < tiers*numPeaks; i++)
      {
        xOffsets[i] = random(100);
      }
     
      for(int i = 0; i < tiers; i++)
      {
        
        //Create base positions
        int tier = i;
        float targetY = tier*lineHeight - height/2;
        
        //Create start point / vertex
        PVector startpoint = new PVector(0, targetY, targetZ);
        PVector preAnchor = null;
        PVector midpoint = new PVector(1*width/numPeaks, targetY, targetZ);
        PVector postAnchor = new PVector(startpoint.x + (midpoint.x - startpoint.x)/4, startpoint.y, startpoint.z);
        
        BezierPoint startBezier = new BezierPoint(startpoint, preAnchor, postAnchor);
        BezierPoint midBeziers[] = new BezierPoint[numPeaks];
                
        PVector priorPoint = startpoint;
        
        PVector targetPositions[] = new PVector[numPeaks];
        
        
        noiseSeed(ranSeed);
        int xOffsetId = 0;
        for(int j = 0; j < numPeaks-1; j++)
        {

          //Figure out our offset for each peak on a time basis - this should be only the target offset
          midpoint = new PVector((j+1)*width/numPeaks+random(40)-20, targetY, targetZ);
          xOffsetId++;
          preAnchor = new PVector(midpoint.x - (midpoint.x - priorPoint.x)/4, midpoint.y, midpoint.z);
          postAnchor = new PVector(midpoint.x + (((j+2)*width/numPeaks) - midpoint.x)/4, midpoint.y, midpoint.z);
          midBeziers[j] = new BezierPoint(midpoint, preAnchor, postAnchor);
          priorPoint = midpoint;
          
          targetPositions[j] = new PVector(0,0,noise(j*20)*(maxOffset - minOffset)+minOffset);
        }
        
        PVector endpoint = new PVector(width, targetY, targetZ);
        preAnchor = new PVector(priorPoint.x + (endpoint.x - priorPoint.x)/4, priorPoint.y, priorPoint.z);
        postAnchor = null;// new PVector(endpoint.x - (endpoint.x - priorPoint.x)/4, endpoint.y, endpoint.z);
        BezierPoint endBezier = new BezierPoint(endpoint, preAnchor, postAnchor);
        
        curvylines[i] = new CurvyLine(startBezier, midBeziers, endBezier);
        
        //Create target positions
        curvylines[i].midpointTargetOffsets = targetPositions;
        
      }
     
     
       
   }
   
   void drawCurves(float yPosition, boolean moveOut)
   {
     strokeWeight(1);      
     stroke(100);
     noFill();
      
      int dotId = 0;
      //Time since last stage
      float dif = (millis() - lastStageTime)/10;
      for(int i = 0; i < tiers; i++)
      {
        CurvyLine curve = curvylines[i];
        curve.draw(yPosition);
        if(moveOut)
        { 
          curve.moveTowardTarget(dif/this.stageTimings[this.stage]);
        }else{
          curve.returnToOriginal(dif/this.stageTimings[this.stage]);
        }

      }
      
   }
   
   void spinDrawCurves()
   {
      translate(0, height/2, 0);
      rotateX(spinDrawAngle);
      drawCurves(-height/2, true);
      spinDrawAngle += 0.008f;
      if(spinDrawAngle > PI*2){
        this.stage++;
        lastStageTime = millis();
      }
   }
   
}

class CurvyLine
{
  
  BezierPoint startpoint;
  BezierPoint midpoints[];
  BezierPoint originalMidpoints[];
  BezierPoint endpoint;
  
  PVector midpointTargetOffsets[];
  
  CurvyLine(BezierPoint startpoint, BezierPoint midpoints[], BezierPoint endpoint)
  {
    this.startpoint = startpoint;
    this.originalMidpoints = this.midpoints = midpoints;
    this.endpoint = endpoint;
    
  }
  
  void moveTowardTarget(float dt)
  {
    for(int i = 0; i < this.midpoints.length-1; i++)
    {
      float currentZ = this.midpoints[i].position.z;
      //lerp(this.position.x, this.targetPosition.x, dif/this.timeToTargetMS);
      this.midpoints[i].position.z = this.midpoints[i].preAnchor.z = this.midpoints[i].postAnchor.z = lerp(currentZ, this.midpointTargetOffsets[i].z, dt);
    }
    
  }
  
  void returnToOriginal(float dt)
  {
    for(int i = 0; i < this.midpoints.length-1; i++)
    {
      float currentZ = this.midpoints[i].position.z;
      //lerp(this.position.x, this.targetPosition.x, dif/this.timeToTargetMS);
      this.midpoints[i].position.z = this.midpoints[i].preAnchor.z = this.midpoints[i].postAnchor.z = lerp(currentZ, startpoint.position.z, dt);
    }
  }
  
  void draw(float yPosition)
  {
    beginShape();
     
    vertex(this.startpoint.position.x, this.startpoint.position.y+yPosition, this.startpoint.position.z);
    
    BezierPoint priorPoint = this.startpoint;

    for(int j = 1; j < this.midpoints.length-1; j++)
    {
      BezierPoint currentPoint = this.midpoints[j];
      bezierVertex(priorPoint.postAnchor.x, priorPoint.postAnchor.y+yPosition, priorPoint.postAnchor.z, currentPoint.preAnchor.x, currentPoint.preAnchor.y+yPosition, currentPoint.preAnchor.z, 
          currentPoint.position.x, currentPoint.position.y+yPosition, currentPoint.position.z);
      priorPoint = currentPoint;
    }        

    bezierVertex(priorPoint.postAnchor.x, priorPoint.postAnchor.y+yPosition, priorPoint.postAnchor.z, this.endpoint.preAnchor.x, this.endpoint.preAnchor.y, this.endpoint.preAnchor.z, this.endpoint.position.x, this.endpoint.position.y+yPosition, this.endpoint.position.z);

    endShape();
    
  }
}

class BezierPoint
{
  PVector position;
  PVector preAnchor;
  PVector postAnchor;
  
  BezierPoint(PVector position, PVector preAnchor, PVector postAnchor)
  {
    this.position = position;
    this.preAnchor = preAnchor;
    this.postAnchor = postAnchor;
  }
}
