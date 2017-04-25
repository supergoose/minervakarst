Dot[] dots;
int numDots = 8000;

ScreenBehaviour screenBehaviour;

float changeTimeMS = 100000;
float changeTimeElapsed = 0;
float lastFrameMS = 0;
int iterations = 0;

void setup()
{
  size(1024, 768, P3D);
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

  assignNewBehaviour(2);
}

void draw()
{
  background(0);

  if (millis() - changeTimeElapsed > changeTimeMS)
  {
    //screenBehaviour = new ChaosScreenBehaviour(dots);
    assignNewBehaviour(2);
    iterations++;
    changeTimeElapsed = millis();
    print("Iterations: " + iterations);
  }

  screenBehaviour.update();
  screenBehaviour.draw();
}

void assignNewBehaviour()
{
   int newBehaviourId = round(random(0, 2));
   assignNewBehaviour(newBehaviourId);
}

void mouseClicked() {
  assignNewBehaviour();
}

void assignNewBehaviour(int behaviourId)
{
   switch(behaviourId)
   {
     case 0:
       screenBehaviour = new InOutScreenBehaviour(dots);
       break;
     case 1:
       screenBehaviour = new ChaosScreenBehaviour(dots);
       break;
     case 2:
       screenBehaviour = new CurvesScreenBehaviour(dots);
       break;
     default:
       print("Failed to change behaviour");
   }
}