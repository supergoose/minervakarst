class InOutScreenBehaviour implements ScreenBehaviour{
  
  Dot[] dots;
  CircleBoundary boundary;
  
  InOutScreenBehaviour(Dot[] dots)
  {
     this.dots = dots;
     
     boundary = new CircleBoundary(new PVector(width/2, height/2, 0), height/4);
     
     for(int i = 0; i < this.dots.length; i++)
     {
       this.dots[i].setBehaviour(new InOutDotBehaviour(dots[i].position, this.boundary)); 
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