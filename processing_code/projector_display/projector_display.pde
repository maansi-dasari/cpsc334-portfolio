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
int MIN_BLOBS = 8;
int MAX_BLOBS = 15;

float MAX_VELOCITY_SCALE = 0.005;
float MAX_RADIUS_SCALE = 0.06;
float MIN_RADIUS_SCALE = 0.03;

void setup() {
  fullScreen();
  
  // Load screen information from JSON file
  JSONArray screens = loadJSONArray("../screen_coords.json");
  
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
  
  // Generate random color parameters
  float range = random(50, 100);
  float redMin = random(100,200);
  float greenMin = random(100,200);
  float blueMin = random(100,200);
  
  float MIN_RADIUS = min(screen.sizeX, screen.sizeY) / 30;
  float MAX_RADIUS = min(screen.sizeX, screen.sizeY) / 15;
  
  // Color screen background based on generated color ranges
  screen.backgroundColor = color(redMin-50, greenMin-50, blueMin-50);
  fill(screen.backgroundColor);
  noStroke();
  rect(screen.minX, screen.minY, screen.sizeX, screen.sizeY);
  
  // Generate each blob object
  for (int i = 0; i < numBlobs; i++) {
    Blob tempBlob = new Blob();
    tempBlob.radius = random(MAX_RADIUS - MIN_RADIUS) + MIN_RADIUS;
    
    boolean goodCoord = false;
    
    // Create non-overlapping center positions for blobs
    while (!goodCoord) {
      goodCoord = true;
      
      // Generate set of coordinates
      tempBlob.centerX = random(screen.sizeX - 2 * tempBlob.radius) + screen.minX + tempBlob.radius;
      tempBlob.centerY = random(screen.sizeY - 2 * tempBlob.radius) + screen.minY + tempBlob.radius;
      
      // Check intersection
      for (int j = 0; j < blobs.size(); j++) {
        if (blobIntersect(tempBlob, blobs.get(j))) {
          goodCoord = false;
          break;
        }
      }
    }
    
    // Generate velocity and color
    float maxVelocity = min(screen.sizeX, screen.sizeY) * MAX_VELOCITY_SCALE;
    tempBlob.velocityX = random(maxVelocity * (1 - tempBlob.radius / MAX_RADIUS));
    tempBlob.velocityY = random(maxVelocity * (1 - tempBlob.radius / MAX_RADIUS));
    tempBlob.blobColor = color(random(redMin, redMin+range), random(greenMin, greenMin+range), random(blueMin, blueMin+range));
    
    blobs.add(tempBlob);
  }
  screen.blobs = blobs;
}

// Check if two blobs are overlapping
boolean blobIntersect(Blob b1, Blob b2) {
  float distance = sqrt(pow(b1.centerX - b2.centerX, 2) + pow(b1.centerY - b2.centerY, 2));
  return (distance < (b1.radius + b2.radius));
}

float weightedAvg(float v1, float v2, float w1, float w2) {
  return (w1 * v1 + w2 * v2) / (w1 + w2);
}

void collideBlobs(Screen s, Blob b1, Blob b2) {
  float minRadius = min(s.sizeX, s.sizeY) * MIN_RADIUS_SCALE;
  float maxRadius = min(s.sizeX, s.sizeY) * MAX_RADIUS_SCALE;
  float totalRadius = b1.radius + b2.radius;
  
  // Redistribute blob size
  b1.radius = random(max(minRadius, totalRadius - maxRadius), min(maxRadius, totalRadius - minRadius));
  b2.radius = totalRadius - b1.radius;

  // Reassign velocity in opposite direction of collision 
  b1.velocityX = random(0.01) * (b1.centerX - b2.centerX);
  b1.velocityY = random(0.01) * (b1.centerY - b2.centerY);
  b2.velocityX  = random(0.01) * (b2.centerX - b1.centerX);
  b2.velocityY = random(0.01) * (b2.centerY - b1.centerY);

  // Redistribute total color values
  float totalRed = red(b1.blobColor) + red(b2.blobColor);
  float totalGreen = green(b1.blobColor) + green(b2.blobColor);
  float totalBlue = blue(b1.blobColor) + blue(b2.blobColor);
  
  b1.blobColor = color(min(255, totalRed * random(0.4,0.6)), min(255, totalGreen * random(0.4,0.6)), min(255, totalBlue * random(0.4,0.6)));
  b2.blobColor = color(totalRed - red(b1.blobColor), totalGreen - green(b1.blobColor), totalBlue - blue(b1.blobColor));
  
}

void moveBlobs(Screen screen) {
  for (int i = 0; i < screen.blobs.size(); i++) {
    Blob b = screen.blobs.get(i);
    b.centerX += b.velocityX;
    b.centerY += b.velocityY;
    
    if (b.centerX - b.radius <= screen.minX) {
      b.velocityX = abs(b.velocityX);
      b.centerX += b.velocityX;
    }
    else if (b.centerX + b.radius >= screen.minX + screen.sizeX) {
      b.velocityX = -1 * abs(b.velocityX);
      b.centerX += b.velocityX;
    }
    
    if (b.centerY - b.radius <= screen.minY) {
      b.velocityY = abs(b.velocityY);
      b.centerY += b.velocityY;
    }
    else if (b.centerY + b.radius >= screen.minY + screen.sizeY) {
      b.velocityY = -1 * abs(b.velocityY);
      b.centerY += b.velocityY;
    }
    
    // Check blob intersection
    for (int j = i + 1; j < screen.blobs.size(); j++) {
       if (blobIntersect(b, screen.blobs.get(j))) {
         collideBlobs(screen, b, screen.blobs.get(j));
         continue;
       }
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

void draw() {
  for (int i = 0; i < screenList.size(); i++) {
    moveBlobs(screenList.get(i));
    drawBlobs(screenList.get(i));
  }
}
