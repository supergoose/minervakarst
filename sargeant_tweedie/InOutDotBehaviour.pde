class InOutDotBehaviour implements DotBehaviour{
  
  CircleBoundary boundary;
  
  PVector velocity;
  PVector position;
  
  float speed;
  float direction;
  
  boolean returning;
  
  InOutDotBehaviour(PVector position, CircleBoundary boundary)
  {
    this.position = position;
    this.boundary = boundary;
    
    this.direction = random(0,PI*2);
    this.speed = 2;
    
    this.velocity = this.calculateVelocity();
    
    this.returning = false;
  }
  
  PVector calculateVelocity()
  {
    return new PVector(cos(this.direction)*this.speed, sin(this.direction)*this.speed);
  }
  
  PVector update(PVector position)
  {
    this.velocity = this.calculateVelocity();
    
    if(!boundary.checkPointWithin(new PVector(this.position.x+this.velocity.x, this.position.y+this.velocity.y)))
    {
      //calculate the angle of incidence
      
      float reflection = getBounceReflection();
      this.direction -= reflection;
      
      if(!this.returning)
      {
        this.velocity.x = cos(this.direction)*speed;
        this.velocity.y = sin(this.direction)*speed;
        this.returning = true;
      }
      
    }else{
      this.returning = false;
    }
    
    this.position.add(this.velocity);
    
    return this.position;
  }
  
  public float getBounceReflection()
  {
      float myAngle = atan2(this.position.y-boundary.position.y, this.position.x-boundary.position.x);
      float normalAngle = myAngle+PI;
      
      float reflection = this.direction - normalAngle;// + PI;
      
      return reflection;
  }
}