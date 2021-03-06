import org.openkinect.freenect.*;
import org.openkinect.processing.*;

// Kinect Library object
Kinect kinect;

Dot[] dots;
int numDots = 9000;

ScreenBehaviour screenBehaviour;

float speed = 0.2f;
float changeTimeMS = 30000*speed; //10000;
float shortChangeTimeMS = 30000*speed;
float longChangeTimeMS = 120000*speed; //40000;
float changeTimeElapsed = 0;
float lastFrameMS = 0;
int iterations = 0;
int oldBehaviourId = 0;

void setup()
{
  //size(1024, 768, P3D);
size(displayWidth, displayHeight, P3D); 
  kinect = new Kinect(this);
  print("Kinect: " + kinect);
  kinect.initDepth();
  background(0);
  stroke(255);

  dots = new Dot[numDots];
  for (int i = 0; i < numDots; i++)
  {
    float x = random(0, width);
    float y = random(0, height);
    float z = 0;

    dots[i] = new Dot(new PVector(x, y, z));
  }

  assignNewBehaviour(1);
}

boolean sketchFullScreen() {
  return true;
}



void draw()
{
  background(0);

  if (millis() - changeTimeElapsed > changeTimeMS)
  {
    //screenBehaviour = new ChaosScreenBehaviour(dots);
    assignNewBehaviour();
    iterations++;
    changeTimeElapsed = millis();
    print("Iterations: " + iterations);
  }

  screenBehaviour.update();
  screenBehaviour.draw();
}

void assignNewBehaviour()
{
   int newBehaviourId = 0;
   while(newBehaviourId == oldBehaviourId)
   {
     newBehaviourId = floor(random(0, 3.9));
   }
   assignNewBehaviour(newBehaviourId);
}

void mouseClicked() {
  assignNewBehaviour();
}

void assignNewBehaviour(int behaviourId)
{
  oldBehaviourId = behaviourId;
  screenBehaviour = null;
  System.gc();
  print("Assigning behaviour");
   switch(behaviourId)
   {
     case 0:
       screenBehaviour = new InOutScreenBehaviour(dots);
       changeTimeMS = shortChangeTimeMS;
       break;
     case 1:
       screenBehaviour = new ChaosScreenBehaviour(dots);
       changeTimeMS = shortChangeTimeMS;
       break;
     case 2:
       screenBehaviour = new CurvesScreenBehaviour(dots);
       changeTimeMS = longChangeTimeMS;
       break;
     case 3:
       changeTimeMS = longChangeTimeMS;
       screenBehaviour = new KinectScreenBehaviour(dots, kinect, changeTimeMS);
       break;
     default:
       print("Failed to change behaviour");
   }
}
