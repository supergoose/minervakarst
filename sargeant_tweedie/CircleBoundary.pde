class CircleBoundary{
  
  //Position
  PVector position;
  
  float radius;
  float radiusSquared;
  
  CircleBoundary(PVector position, float radius)
  {
    this.position = position;
    this.radius = radius;
    this.radiusSquared = radius*radius;
  }
  
  public void draw()
  {
    strokeWeight(1);
    noFill();
    ellipse(this.position.x, this.position.y, this.radius*2, this.radius*2);
  }
  
  public boolean checkPointWithin(PVector pointPosition)
  {
    float dist = pointPosition.dist(this.position);
    
    return (dist*dist < radiusSquared);
  }
}