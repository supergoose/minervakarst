class Dot{
  
  DotBehaviour behaviour;
  
  PVector position;
  PVector originalPosition;
  PVector lastPosition;
  
  Dot(PVector position){
     this.position = position;
     this.originalPosition = position;
     this.lastPosition = position;
  }
  
  void reset(){
    this.position = this.originalPosition;
  }
  
  void setBehaviour(DotBehaviour behaviour)
  {
    this.behaviour = behaviour;
  }
  
  void update()
  {
    this.lastPosition = this.position;
    this.position = this.behaviour.update(this.position);
  }
  
}