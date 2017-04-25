class ChaosScreenBehaviour implements ScreenBehaviour{
  
  Dot[] dots;
  CircleBoundary boundary;
  
  ChaosScreenBehaviour(Dot[] dots)
  {
     this.dots = dots;
     
     boundary = new CircleBoundary(new PVector(width/2, height/2, 0), height/3);
     
     for(int i = 0; i < this.dots.length; i++)
     {
       this.dots[i].setBehaviour(new ChaosDotBehaviour(dots[i].position, this.boundary)); 
     }
  }
  
  public void update()
  {
    for(int i = 0; i < this.dots.length; i++)
     {
       this.dots[i].update();
     }
  }
  
  public void draw()
  {
    //boundary.draw();
    
    strokeWeight(2);
    beginShape(POINTS);
    
    for(int i = 0; i < dots.length; i++)
    {
      vertex(dots[i].position.x, dots[i].position.y, dots[i].position.z);
    }
    
    endShape();
  }
}