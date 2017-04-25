class CurvesScreenBehaviour implements ScreenBehaviour{
  
   Dot dots[];
   Dot dotsTiered[][];
   
   int tiers = 20;
   
   int stage = 0;
   float stageTimings[] = {5000, 500, 5000, 5000};
   float lastStageTime = 0;
   float lineHeight;
   
   int numPeaks = 8;
   float offset[];
   float targetOffset[];
   float minOffset = -200.0f;
   float maxOffset = 200.0f;
   int seed;
   float spinDrawAngle = 0.0f;
  
   CurvesScreenBehaviour(Dot[] dots)
   {
      this.dots = dots;
      this.dotsTiered = new Dot[tiers][ceil((float)this.dots.length/(float)tiers)];
      print("dots per tier: " + ceil((float)this.dots.length/(float)tiers));
      //Seperate dots into lines from where they are
      //Get the highest dot
      
      lineHeight = height/tiers;
      int dotId = 0;
      for(int i = 0; i < tiers; i++)
      {
        for(int j = 0; j < ceil((float)this.dots.length/(float)tiers) && dotId < this.dots.length; j++)
        {
           int tier = i%tiers;
           float targetY = tier*lineHeight + lineHeight/2;
           
           float targetX = random(0,width);
           this.dots[dotId].setBehaviour(new CurvesDotBehaviour(this.dots[i].position, new PVector(targetX, targetY)));
           
           this.dotsTiered[i][j] = dots[dotId];
           dotId++;
        }
        
        
      }
      print("Dots created: " + dotId);
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
          drawCurves(0.0f);
          break;
        case 3:
          drawCurves(0.0f);
          break;
          
      }
      
      if(millis()-lastStageTime > stageTimings[this.stage])
      {
        this.stage++;
        lastStageTime = millis();
        if(this.stage > this.stageTimings.length-1)this.stage = 0;
        
        offset = new float[numPeaks];
        targetOffset = new float[numPeaks];
        for(int i = 0; i < numPeaks; i++)
        {
          targetOffset[i] = random(minOffset, maxOffset);
        }
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
        float targetY = tier*lineHeight + lineHeight/2;
        vertex(0, targetY, this.dotsTiered[i][0].position.z);
        vertex(width, targetY, this.dotsTiered[i][0].position.z);
        
      }
      endShape();
   }
   
   void drawCurves(float yPosition)
   {
     strokeWeight(1);      
     stroke(100);
     noFill();
      
      int dotId = 0;
      for(int i = 0; i < tiers; i++)
      {
        beginShape();
        int tier = i%tiers;
        float targetY = tier*lineHeight + lineHeight/2 + yPosition;
        float targetZ = this.dotsTiered[i][0].position.z;
        
        //Create and draw start point / vertex
        PVector startpoint = new PVector(0, targetY, targetZ);
        vertex(startpoint.x, startpoint.y, startpoint.z);
        
        PVector priorPoint = startpoint;
        
        //Time since last stage
        float dif = (millis() - lastStageTime)/100;
        for(int j = 0; j < numPeaks; j++)
        {

          //Figure out our offset for each peak
          offset[j] = lerp(offset[j], targetOffset[j], dif/this.stageTimings[this.stage]);
          PVector midpoint = new PVector(j*width/numPeaks, targetY, targetZ - offset[j]);
          PVector startAnchor = new PVector(priorPoint.x + (midpoint.x - priorPoint.x)/4, priorPoint.y, priorPoint.z);
          PVector midpointAnchorL = new PVector(midpoint.x - (midpoint.x - priorPoint.x)/4, midpoint.y, midpoint.z);
          bezierVertex(startAnchor.x, startAnchor.y, startAnchor.z, midpointAnchorL.x, midpointAnchorL.y, midpointAnchorL.z, midpoint.x, midpoint.y, midpoint.z);
          
          priorPoint = midpoint;
        }        
        
        
        PVector endpoint = new PVector(width, targetY, targetZ);
        PVector midpointAnchorR = new PVector(priorPoint.x + (endpoint.x - priorPoint.x)/4, priorPoint.y, priorPoint.z);
        PVector endpointAnchorL = new PVector(endpoint.x - (endpoint.x - priorPoint.x)/4, endpoint.y, endpoint.z);
        
        bezierVertex(midpointAnchorR.x, midpointAnchorR.y, midpointAnchorR.z, endpointAnchorL.x, endpointAnchorL.y, endpointAnchorL.z, endpoint.x, endpoint.y, endpoint.z);

        endShape();
        
        
      }
      
   }
   
   void spinDrawCurves()
   {
      translate(0, height/2, 0);
      rotateX(spinDrawAngle);
      drawCurves(-height/2);
      spinDrawAngle += 0.008f;
   }
   
}