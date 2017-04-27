class KinectScreenBehaviour implements ScreenBehaviour
{
  Dot dots[];
  Dot dotsTiered[][];
  
  float lineHeight;
  float columnWidth;
  
  int rows = 120;
  int columns = 160;
  int skip = 8;
  float spinDrawAngle = 0.0f;
  float zpos = 0.0f;
  float xpos = width/2;
  float targetZpos = -1000.0f;
  float moveTime = 100000.0f;
  float startMoveTime = 0.0f;
  float duration;
  float startTime;
  float[] depthLookUp = new float[2048];
  float depthCutoff = 1500;
  float factor = 400; //1200;
  float zFactor = 0.0f;
  float spreadContinuity = 500;
  int[] depth;
  int[] lastDepth;
  float lastFrameTime;
  int totalKinectPoints;
  float targetSpinAngle;
  
  KinectScreenBehaviour(Dot[] dots, Kinect kinect, float duration)
   {
      this.dots = dots;
      
      // Lookup table for all possible depth values (0 - 2047)
      for (int i = 0; i < depthLookUp.length; i++) {
        depthLookUp[i] = rawDepthToMeters(i);
      }
      
      //Seperate dots into lines from where they are
      //Get the highest dot
      
      this.duration = duration;// - moveTime/10;
      
      startMoveTime = startTime =  millis();
      
      depth = kinect.getRawDepth();
      int numP = 0;
      for (int x = 0; x < kinect.width; x += skip) {
          for (int y = 0; y < kinect.height; y += skip) {
            
            if(numP >= this.dots.length)return;
            
            int offset = x + y*kinect.width;
    
            // Convert kinect data to world xyz coordinate
            int rawDepth = depth[offset];
            
             PVector k = new PVector(x, y, rawDepth);
              
             if(rawDepth < depthCutoff)
             {
               PVector v = depthToWorld((int)k.x, (int)k.y, (int)k.z);
               PVector thisPoint = new PVector(v.x*factor*k.z/spreadContinuity, v.y*factor*k.z/spreadContinuity, factor-v.z*zFactor);
               this.dots[numP].setBehaviour(new KinectEntryDotsBehaviour(this.dots[numP].position, new PVector(thisPoint.x, thisPoint.y, thisPoint.z)));
             }
             numP++;
            
          }
      }
      
      for(int i = numP; i < this.dots.length; i++)
      {
        //if(this.dots[i].behaviour != null)
        //{
          //if(this.dots[i].behaviour.getClass() != KinectEntryDotsBehaviour.class)
          //{
            this.dots[i].setBehaviour(new KinectEntryDotsBehaviour(this.dots[i].position, new PVector(this.dots[i].position.x, height, random(0, 2048))));
          //}
        //}else{
          //this.dots[i].setBehaviour(new KinectEntryDotsBehaviour(this.dots[i].position, new PVector(this.dots[i].position.x, height, random(0, 2048))));
        //}
        
        
      }
      
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
      strokeWeight(2);    

     float d = millis() - startMoveTime;
     float b = millis() - startTime;
     
     if(d < this.duration/6)
     {
       beginShape(POINTS);
       for(int i = 0; i < this.dots.length; i++)
         {
           vertex(this.dots[i].position.x, this.dots[i].position.y, this.dots[i].position.z);
         }
       endShape();
     }else if (d < this.duration - this.duration/3){

       zFactor ++;
      
      float dt = millis() - lastFrameTime;
      lastFrameTime = millis();
      
      lastDepth = new int[depth.length];
      arrayCopy(depth, lastDepth);
      spinDrawAngle += 0.008f;
      
      if(b/moveTime < 1)zpos = lerp(zpos, targetZpos, b/moveTime);
      
      translate(width/2, 0, zpos);
      rotateY(spinDrawAngle);
      
      if(depth.length == 0) return;
      
      PVector kPoints[] = new PVector[depth.length];
   
       //Loop through all points and create an array containing them all
       int numP=0;
       beginShape(POINTS);
       for (int x = 0; x < kinect.width; x += skip) {
          for (int y = 0; y < kinect.height; y += skip) {
            
            int offset = x + y*kinect.width;
    
            // Convert kinect data to world xyz coordinate
            int rawDepth = lastDepth[offset];

            PVector pos = this.dots[numP].position;
            this.dots[numP].position = new PVector(x, y, rawDepth);
            PVector k = this.dots[numP].position;
            
            if(rawDepth < depthCutoff)
            {
              PVector v = depthToWorld((int)k.x, (int)k.y, (int)k.z);
              PVector thisPoint = new PVector(v.x*factor*k.z/spreadContinuity, v.y*factor*k.z/spreadContinuity, factor-v.z*zFactor);
              this.dots[numP].position = thisPoint;
              vertex(thisPoint.x, thisPoint.y, thisPoint.z);
            }
            
            numP++;
          }
       }
       endShape();
     }else{
       float lpercent = (1-((this.duration - (millis()-this.startMoveTime))/10000)) ;
       if(startTime == startMoveTime)startTime = millis();
       zpos = lerp(zpos, 0, lpercent);
       xpos = lerp(xpos, 0, lpercent);
       if(targetSpinAngle==0)targetSpinAngle = ceil(spinDrawAngle/TWO_PI)*TWO_PI;
       
       spinDrawAngle = lerp(spinDrawAngle, targetSpinAngle, lpercent);
       
       translate(xpos, 0, zpos);
       rotateY(spinDrawAngle);
       beginShape(POINTS);
       
       for(int i = 0; i < this.dots.length; i++)
       {
         if(this.dots[i].behaviour.getClass() == KinectEntryDotsBehaviour.class)
         {
           KinectEntryDotsBehaviour behaviour = (KinectEntryDotsBehaviour)this.dots[i].behaviour;
         if(behaviour.targetPosition.z != 0)
         {
           float xPos = random(0,width);
           float yPos = random(0,height);
           float zPos = 0;
           behaviour.setTargetPosition(new PVector(xPos, yPos, zPos));
         }

         vertex(this.dots[i].position.x, this.dots[i].position.y, this.dots[i].position.z);
         }
         
       }

       endShape();
       
     }
     
      
      
   }
   
   // These functions come from: http://graphics.stanford.edu/~mdfisher/Kinect.html
  float rawDepthToMeters(int depthValue) {
    if (depthValue < 2047) {
      return (float)(1.0 / ((double)(depthValue) * -0.0030711016 + 3.3309495161));
    }
    return 0.0f;
  }
  
  PVector depthToWorld(int x, int y, int depthValue) {
  
    final double fx_d = 1.0 / 5.9421434211923247e+02;
    final double fy_d = 1.0 / 5.9104053696870778e+02;
    final double cx_d = 3.3930780975300314e+02;
    final double cy_d = 2.4273913761751615e+02;
  
    PVector result = new PVector();
    double depth =  depthLookUp[depthValue];//rawDepthToMeters(depthValue);
    result.x = (float)((x - cx_d) * depth * fx_d);
    result.y = (float)((y - cy_d) * depth * fy_d);
    result.z = (float)(depth);
    return result;
  }
  
}
