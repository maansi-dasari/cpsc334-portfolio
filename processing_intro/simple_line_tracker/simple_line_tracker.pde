

int screenHeight = 768;
int screenWidth = 8160;

// Objects to store screen coordinates
JSONArray screenArray = null;
JSONObject screenCoords = null;

void settings() {
  smooth();
}

void setup() {
  surface.setSize(screenWidth, screenHeight);
  surface.setLocation(1024, 0);
  edge1.x = 250;
  edge1.y = 250;
  
  // Create JSON array to hold coordinates for each screen
  screenArray = new JSONArray();
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

void mousePressed() {
  if (screenCoords == null) {
    // Create a new JSON object to store coordinates
    screenCoords = new JSONObject();
    // Store clicked position as top left coordinate
    screenCoords.setInt("top_left_x", mouseX);
    screenCoords.setInt("top_left_y", mouseY);
  }
  else {
    // Store clicked position as bottom right coordinate
    screenCoords.setInt("bottom_right_x", mouseX);
    screenCoords.setInt("bottom_right_y", mouseY);
    // Append screen coordinates to array of all screens
    screenArray.append(screenCoords);
    // Reset coordinates for next screen
    screenCoords = null;
  }
}

void keyPressed() {
  saveJSONArray(screenArray, "screen_coords.json");
  exit();
}
