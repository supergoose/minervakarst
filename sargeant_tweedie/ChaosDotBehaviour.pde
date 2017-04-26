class ChaosDotBehaviour extends InOutDotBehaviour{
  ChaosDotBehaviour(PVector position, CircleBoundary boundary)
  {
    super(position, boundary);
  }
  
  public float getBounceReflection()
  {
      float myAngle = atan2(this.position.y-boundary.position.y, this.position.x-boundary.position.x);
      float normalAngle = myAngle+PI;
      
      float reflection = this.direction - normalAngle;// + PI;
      reflection += radians(random(-90,90));
      
      return reflection;
  } 
}
