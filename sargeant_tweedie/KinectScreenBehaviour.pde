class KinectScreenBehaviour implements ScreenBehaviour
{
  Dot dots[];
  Dot dotsTiered[][];
  
  float lineHeight;
  float columnWidth;
  
  int rows = 120;
  int columns = 160;
  int skip = 4;
  float spinDrawAngle = 0.0f;
  float zpos = 0.0f;
  float targetZpos = -900.0f;
  float moveTime = 100000.0f;
  float startMoveTime = 0.0f;
  float duration;
  float startTime;
  
  KinectScreenBehaviour(Dot[] dots, float duration)
   {
      this.dots = dots;
      this.dotsTiered = new Dot[rows][columns];
      
      //Seperate dots into lines from where they are
      //Get the highest dot
      
      this.duration = duration - moveTime/10;
      
      
      float colWidth = width/columns;
      float rowHeight = height/rows;
      
      for(int i = 0; i < this.dots.length; i++)
      {
           float targetX = i%columns; 
           float targetY = (i-targetX)/columns;
           //random(0,width);
           this.dots[i].setBehaviour(new KinectEntryDotsBehaviour(this.dots[i].position, new PVector(targetX*colWidth, targetY*rowHeight)));
      }
      
      startMoveTime = startTime =  millis();
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
      float d = millis()-startMoveTime;
      zpos = lerp(zpos, targetZpos, d/moveTime);
      
      translate(width/2, 0, zpos);
      rotateY(spinDrawAngle);
      
      beginShape(POINTS);
      int dotId = 0;
      
      for(int i = 0; i < this.dots.length; i++)
      {
          vertex(this.dots[i].position.x-width/2,this.dots[i].position.y, 0);
          dotId++;
      }
      
      endShape();
      
      spinDrawAngle += 0.04f;
      
      if(this.duration - startTime < moveTime/10)
      {
        targetZpos = 0.0f;
        startMoveTime = millis();
      }
   }
  
}