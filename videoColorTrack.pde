import processing.video.*;
Capture video;
color trackColor;

ArrayList<Blob> blobs = new ArrayList<Blob>();

void setup() {
    size(640, 480);  
    background(0);
    video = new Capture(this, width, height);
    video.start();
    trackColor = color(255, 0, 0);
}

void captureEvent(Capture video) {  
    video.read();
}

float smoothX = 0, smoothY = 0;
void draw() {
    drawMirrorVideo();
    video.loadPixels();
    blobs.clear();

    video.loadPixels();
    int sumX = 0, sumY = 0;
    int qualifiedCount = 0;
    for(int x = 0; x < video.width; x++){
        for(int y = 0; y < video.height; y++){
            int mirrorLoc = (video.width-x-1) + y*video.width;
            int actualLoc = x + y*video.width;

            color currentColor = video.pixels[mirrorLoc];
            float r1 = red(currentColor);
            float g1 = green(currentColor);
            float b1 = blue(currentColor);

            float r2 = red(trackColor);
            float g2 = green(trackColor);
            float b2 = blue(trackColor);

            float d = distSq(r1, g1, b1, r2, g2, b2);
            float threshold = 3000;
            if(d < threshold){
                sumX += x;
                sumY += y;
                qualifiedCount++;
            }
            else{
            }
        }
    }

    if(qualifiedCount > 0){
        float avgX = sumX / qualifiedCount;
        float avgY = sumY / qualifiedCount;
        smoothX = lerp(smoothX, avgX, 0.25);
        smoothY = lerp(smoothY, avgY, 0.25);

        //fill(200, 130, 140);
        fill(trackColor);
        ellipse(avgX, avgY, 40, 40);
    }

}

float distSq(float r1, float g1, float b1, float r2, float g2, float b2){
    return (r1-r2)*(r1-r2) + (g1-g2)*(g1-g2) + (b1-b2)*(b1-b2);
}

void mousePressed() {
    int loc = (width-1-mouseX) + mouseY*width;
    trackColor = video.pixels[loc];
    println(red(trackColor)+" "+green(trackColor)+" "+blue(trackColor));
}

void drawMirrorVideo() {
    pushMatrix();
    scale(-1, 1);
    image(video, -video.width, 0);
    popMatrix();
}