class KinectEntryDotsBehaviour implements DotBehaviour
{
  
  PVector targetPosition;
  PVector position;
  PVector velocity;
  boolean reachedTarget = false;
  float timeToTargetMS = 50000.0f;
  float startTimeMS;
  
  float speed = 2;

  KinectEntryDotsBehaviour(PVector position, PVector targetPosition)
  {
     this.position = position;
     this.targetPosition = targetPosition;
     this.startTimeMS = millis();
  }
  
  public void resetStartTime()
  {
    this.startTimeMS = millis();
  }
  
  public void setTargetPosition(PVector targetPosition)
  {
    this.targetPosition = targetPosition;
  }

  
  PVector calculateVelocity()
  {
     if(this.reachedTarget)this.velocity.y = 0;

     float dif = millis()-startTimeMS;
     
     if(dif < this.timeToTargetMS)
     {
       this.velocity.x = -lerp(this.position.x, this.targetPosition.x, dif/this.timeToTargetMS);
       this.velocity.y = -lerp(this.position.y, this.targetPosition.y, dif/this.timeToTargetMS);
     }
     
     return this.velocity;
  }
  
  public PVector update(PVector position)
  {
    this.position = position;
    
    float dif = millis()-startTimeMS;
     
     if(dif < this.timeToTargetMS)
     {
       this.position.x = lerp(this.position.x, this.targetPosition.x, dif/this.timeToTargetMS);
       this.position.y = lerp(this.position.y, this.targetPosition.y, dif/this.timeToTargetMS);
     }

    return this.position;
  }
  
}
