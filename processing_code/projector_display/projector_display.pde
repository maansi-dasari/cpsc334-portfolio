class Screen {
  int minX;
  int minY;
  int sizeX;
  int sizeY;
  color backgroundColor;
  ArrayList<Blob> blobs;
}

class Blob {
  float centerX;
  float centerY;
  float radius;
  float velocityX;
  float velocityY;
  color blobColor;
}

ArrayList<Screen> screenList;

// Initial randomization parameters
int MIN_BLOBS = 5;
int MAX_BLOBS = 10;
int MIN_RADIUS = 30;
int MAX_RADIUS = 60;
int MAX_VELOCITY = 8;

void setup() {
  fullScreen();
  
  // Load screen information from JSON file
  JSONArray screens = loadJSONArray("screen_coords.json");
  
  screenList = new ArrayList<Screen>();
  // Create screen objects with coordinate information
  for (int i = 0; i < screens.size(); i++) {
    Screen screen = new Screen();
    int topLeftX = screens.getJSONObject(i).getInt("top_left_x");
    int topLeftY = screens.getJSONObject(i).getInt("top_left_y");
    int bottomRightX = screens.getJSONObject(i).getInt("bottom_right_x");
    int bottomRightY = screens.getJSONObject(i).getInt("bottom_right_y");
    
    screen.minX = min(topLeftX, bottomRightX);
    screen.minY = min(topLeftY, bottomRightY);
    screen.sizeX = abs(topLeftX - bottomRightX);
    screen.sizeY = abs(topLeftY - bottomRightY);
    screen.backgroundColor = color(random(255),random(255),random(255));
    screenList.add(screen);
  }
  
  // Create initial blobs for each screen
  for (int i = 0; i < screenList.size(); i++) {
    createBlobs(screenList.get(i));
  }
}

void createBlobs(Screen screen) {
  ArrayList<Blob> blobs = new ArrayList<Blob>();
  int numBlobs = int(random(MAX_BLOBS - MIN_BLOBS)) + MIN_BLOBS;
  float redMin = random(100,200);
  float range = random(50, 100);
  float greenMin = random(100,200);
  float blueMin = random(100,200);
  screen.backgroundColor = color(redMin-50, greenMin-50, blueMin-50);
  for (int i = 0; i < numBlobs; i++) {
    Blob tempBlob = new Blob();
    tempBlob.radius = random(MAX_RADIUS - MIN_RADIUS) + MIN_RADIUS;
    tempBlob.centerX = random(screen.sizeX - 2 * tempBlob.radius) + screen.minX + tempBlob.radius;
    tempBlob.centerY = random(screen.sizeY - 2 * tempBlob.radius) + screen.minY + tempBlob.radius;
    
    tempBlob.velocityX = random(MAX_VELOCITY * (1 - tempBlob.radius / float(MAX_RADIUS)));
    tempBlob.velocityY = random(MAX_VELOCITY * (1 - tempBlob.radius / float(MAX_RADIUS)));
    tempBlob.blobColor = color(random(redMin, redMin+range), random(greenMin, greenMin+range), random(blueMin, blueMin+range));
    blobs.add(tempBlob);
  }
  screen.blobs = blobs;
}

void moveBlobs(Screen screen) {
  for (int i = 0; i < screen.blobs.size(); i++) {
    Blob b = screen.blobs.get(i);
    b.centerX += b.velocityX;
    b.centerY += b.velocityY;
    if (b.centerX - b.radius <= screen.minX || b.centerX + b.radius >= screen.minX + screen.sizeX) {
      b.velocityX *= -1;
      b.centerX += b.velocityX;
    }
    if (b.centerY - b.radius <= screen.minY || b.centerY + b.radius >= screen.minY + screen.sizeY) {
      b.velocityY *= -1;
      b.centerY += b.velocityY;
    }
  }
}

void drawBlobs(Screen screen) {
  for (int i = 0; i < screen.blobs.size(); i++) {
    Blob b = screen.blobs.get(i);
    fill(b.blobColor);
    strokeWeight(0.0);
    circle(b.centerX, b.centerY, 2 * b.radius);
  }
}

void drawScreen(Screen screen) {
  fill(screen.backgroundColor);
  strokeWeight(0.0);
  rect(screen.minX, screen.minY, screen.sizeX, screen.sizeY);
  moveBlobs(screen);
  drawBlobs(screen);
}

void draw() {
  for (int i = 0; i < screenList.size(); i++) {
    drawScreen(screenList.get(i));
  }
}
