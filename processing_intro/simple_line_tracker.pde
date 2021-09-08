
int screenHeight = 192;
int screenWidth = 1000;

void settings() {
  size(screenWidth, screenHeight);
  smooth();
}

void setup() {
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
