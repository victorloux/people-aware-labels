import hypermedia.video.*;
import processing.video.*;
import java.awt.Rectangle;
//import java.awt.Point;

Capture video;
OpenCV opencv;

final int video_height = 320,video_width = 480;

boolean[] display = new boolean[9];
Label[] labels = new Label[2];
PFont font40, font40i, font24;
color bgC = color(140, 140, 250);

boolean altVersion = false;

void setup() {
    size(1024, 768);
    hint(ENABLE_NATIVE_FONTS);
    //size(960, 540, "processing.core.PGraphicsRetina2D");
    // hint(ENABLE_RETINA_PIXELS);

    if (frame != null) {
        frame.setResizable(true);
    }

    // Initialise webcam
    opencv = new OpenCV(this);
    video = new Capture(this, video_width, video_height);
    video.start();  

    // Make the pixels[] array available for direct manipulation
    loadPixels();

    opencv.allocate(video.width,video.height); // create the buffer
    opencv.copy(video);

    // load detection description, here-> front face detection : "haarcascade_frontalface_alt.xml"
    opencv.cascade(OpenCV.CASCADE_FRONTALFACE_ALT_TREE); // ALT_TREE seems to be more efficient
    //opencv.cascade(OpenCV.CASCADE_UPPERBODY); // ALT_TREE seems to be more efficient

    // Labels list
    display[0] = false;
    display[1] = false;
    
    // LoadFonts
    font24 = loadFont("data/DINPro-Bold-24.vlw");
    font40 = loadFont("data/BodoniStd-Bold-40.vlw");
    font40i = loadFont("data/BodoniSixItcEOT-BoldItalic-26.vlw");

    labels[0] = new Label(50, 100, 420, 550, 
    "Blue box", 
    "17th century", 
    "Lorem ipsum dolor sit amet,consectetur adipisicing elit,sed do eiusmod tempor incididunt ut laboreet dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamco", 
    "Lorem ipsum dolor sit amet,consectetur adipisicing elit, sed do eiusmod temporincididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam,quis nostrud exercitation ullamcolaboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit involuptate velit esse cillum dolore eufugiat nulla pariatur. Excepteur sintoccaecat cupidatat non proident, suntin culpa qui officia deserunt mollitanim id est laborum.", display[0], "Kids version kids kids");

    labels[1] = new Label(520, 330, 400, 600,
    "Palm tree", 
    "1982", 
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco", 
    "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.", display[1], "Kids version kids kids");
}

// boolean sketchFullScreen() {
//   return true;
// }


public void stop() {
    opencv.stop();
    super.stop();
}



void draw() {

    if (video.available()) {
        video.read(); // Read a new video frame
        video.loadPixels(); // Make the pixels of video available

        opencv.copy(video);
        opencv.flip(OpenCV.FLIP_HORIZONTAL);

        background(230);

        // grab a new frame
        // and convert to gray
        opencv.read();
        opencv.convert(GRAY);

        // proceed detection
        Rectangle[] faces = opencv.detect(1.2, 2, OpenCV.HAAR_DO_CANNY_PRUNING, 40, 40);

        // display the camera image
        noStroke();
        
        // Flip the image (mirror-like)
        // and display it in the background
        image(opencv.image(), 0, 0, width, height);
        fill(255, 255, 250, 210);
        rect(0, 0, width, height);

        // draw face area(s)
        noFill();
        stroke(255,0,0);

        // For each face detected
        for(int i=0; i < faces.length; i++) {
            float mappedX, mappedY, mappedHeight, mappedWidth;
            mappedX = map(faces[i].x, 0, video_width, 0, width);
            mappedY = map(faces[i].y, 0, video_height, 0, height);
            mappedWidth = map(faces[i].width, 0, video_width, 0, width);
            mappedHeight = map(faces[i].height, 0, video_height, 0, height);

            // Debug rectangles
            noFill();
            stroke(255, 0, 0, 100);
            //rect(mappedX, mappedY, mappedWidth, mappedHeight);
            noStroke();
            textSize(14);
            fill(255, 0, 0, 100);
            text("X: " + faces[i].x + " Y: " + faces[i].y, mappedX, mappedY - 20);
            text("Face #" + (i+1), mappedX, mappedY - 40);

            // For each label there is
            for (int j = 0; j < labels.length; j++)
            {
                // If the face is in the rectangle, and there is only one person
                if (faces.length == 1
                    && (mappedX > labels[j].getX() - 20)
                    && (mappedX + mappedWidth < labels[j].getX() + labels[j].getWidth() + 20)
                    && (mappedY > labels[j].getY() - 40)
                    && (mappedY + mappedHeight) < labels[j].getY() + labels[j].getHeight() + 20)
                {
                    if(!labels[j].displayLonger)
                        labels[j].change = true;
                }

                // If a face went out of a rectangle or if people came in
                // Revert to the summary version 

                else
                {
                    if(labels[j].displayLonger)
                        labels[j].change = true;
                }
            }
        }

        // Display rectangles around labels (debug)

//         for (int j = 0; j < labels.length; j++)
//         {
//             noFill();
//             stroke(255, 0, 0);
//
//             if (labels[j].change == true)
//             {
//                 stroke(0, 255, 0);
//             }
//
//             rect(labels[j].getX() - 20,
//                  labels[j].getY() - 40,
//                  labels[j].getWidth() + 40,
//                  labels[j].getHeight() + 40);
//        }


        fill(200, 0, 0, 120);

        labels[0].draw();
        labels[1].draw();

        fill(255, 0, 0);
        textSize(14);
        text(faces.length + " face" + (faces.length > 1 ? "s" : "") + " detected", width - 150, height - 30);
    }
}


// Debug option: key pressed
void keyPressed() {
    switch(key) {
        case 49:
            labels[0].change = true;
            break;
        case 50:
            labels[1].change = true;
            break;
        case 32: //space
            altVersion = !altVersion;
            break;
    }

}
