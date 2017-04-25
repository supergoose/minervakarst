class CurvesScreenBehaviour implements ScreenBehaviour{
  
   Dot dots[];
   Dot dotsTiered[][];
   
   int tiers = 20;
  
   CurvesScreenBehaviour(Dot[] dots)
   {
      this.dots = dots;
      this.dotsTiered = new Dot[tiers][ceil(this.dots.length/tiers)];
      
      //Seperate dots into lines from where they are
      //Get the highest dot
      float lineHeight = height/tiers;
      
      int dotId = 0;
      for(int i = 0; i < tiers; i++)
      {
        for(int j = 0; j < ceil(this.dots.length/tiers); j++)
        {
           int tier = i%tiers;
           float targetY = tier*lineHeight + lineHeight/2;
           
           float targetX = random(0,width);
           this.dots[dotId].setBehaviour(new CurvesDotBehaviour(this.dots[i].position, new PVector(targetX, targetY)));
           
           this.dotsTiered[i][j] = dots[dotId];
           dotId++;
        }
        
        //Sort this tier according to target x
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
      //beginShape(POINTS);
      
      for(int i = 0; i < tiers; i++)
      {
        beginShape(POINTS);
        for(int j = 0; j < this.dotsTiered[i].length; j++)
        {
          vertex(this.dotsTiered[i][j].position.x, this.dotsTiered[i][j].position.y, this.dotsTiered[i][j].position.z);
        }
        endShape();
      }
      /*
      for(int i = 0; i < dots.length; i++)
      {
         vertex(dots[i].position.x, dots[i].position.y, dots[i].position.z);
      }
      */
      //endShape();
   }
}