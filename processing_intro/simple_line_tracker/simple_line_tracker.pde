
int screenHeight = 768;
int screenWidth = 8160;

void settings() {
  smooth();
}

void setup() {
  surface.setSize(screenWidth, screenHeight);
  surface.setLocation(1024, 0);
  edge1.x = 250;
  edge1.y = 250;
}

class Edge {
  float x;
  float y;
}

Edge edge1 = new Edge();

void draw() {
  background(255);
  line(edge1.x, 0, edge1.x, screenHeight); 
}

void mouseMoved() {
  edge1.x = mouseX;
}

void mouseClicked() {
  println(mouseX);
  println(mouseY);
}
