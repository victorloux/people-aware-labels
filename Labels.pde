class Label {
    int x;
    int y;
    public int width, height;
    int h;
    float contY;
    int w = 400;
    String title;
    String date;
    String summary;
    String longtext;
    String altLongtext;
    boolean displayLonger;
    float cFontSize = 24;

    color titleColour;
    color contentColour;
    int opacity = 0;
    boolean fadeIn = false;
    boolean slideIn = false;
    boolean change = false;
    boolean changeOpa = false;
    int opSpd = 12;


    public Label(int mx, int my, int mwidth, int mheight, String mtitle, String mdate, String msummary, String mlongtext, boolean mdisplayLonger, String maltLongtext)
    {
        x = mx;
        y = my;
        this.width = mwidth;
        this.height = mheight;
        title = mtitle;
        date = mdate;
        summary = msummary;
        longtext = mlongtext;
        displayLonger = mdisplayLonger;
        contY = y;
        altLongtext = maltLongtext;
    }


    // accessors
    public int getX()
    {
        return this.x;
    }

    public int getY()
    {
        return this.y;
    }

    public int getWidth()
    {
        return this.width;
    }

    public int getHeight()
    {
        return this.height;
    }
  
    public void fade()
    {
        if (changeOpa) {
            if (opacity <= 0) {
                // displayLonger = displayLonger?false:true;
                opacity = 0;
                fadeIn = true;
            }

            if (fadeIn && opacity>255) {
                opacity = 255;
                fadeIn = false; 
                changeOpa = false;
            }

            if (fadeIn) {
                opacity += opSpd;
            }
            else 
                opacity -= opSpd;
        }
    }
  
    public void slide()
    {
        if (cFontSize == 16)
            displayLonger = true;

        if (change) {
            if (slideIn) {
                cFontSize += 0.6;
                displayLonger = false;
                opacity = 0;
            }
            
            else 
                cFontSize -= 0.6;
            
            if (cFontSize<16) {
                displayLonger = true;
                cFontSize = 16;
                slideIn = true;
                change = false;
                contY = y;
            }

            if (slideIn && cFontSize>24) {
                cFontSize = 24;
                slideIn = false; 
                change = false;
            }
        }
    
        if (displayLonger) {
            textSize(cFontSize);

            ArrayList s;

            if(altVersion)
                s = wordWrap(altLongtext, w);
            else
                s = wordWrap(longtext, w);


            String st = "";
            for (int i = 0; i <  s.size(); i++) 
                st += (String)s.get(i) + "\n";

            if(contY > y+50 && contY < y+100){
                changeOpa = true;
            }
            
            fill(color(50, 50, 60, opacity));
            text(st, x, contY + 80);
            
            if(contY < (y + h - 50))
              contY += 15;
            
            fill(0, 0);
            noStroke();
            rect(x, y-40, w, h);
        }

        int sy = y+h-40;

        noStroke();

        beginShape();
            fill(bgC, 255-opacity); 
            vertex(x,sy);
            fill(bgC, 255-opacity);
            vertex(x+w,sy);
            fill(bgC, 0);
            vertex(x+w,sy+40);
            fill(bgC, 0);
            vertex(x,sy+40);
        endShape(CLOSE);
    }

    public void draw()
    {   
        slide();
        fade();

        color titleColour = color(20, 20, 30);
        color contentColour = color(50, 50, 60);

        textFont(font40);
        fill(titleColour);
        textSize(40);
        text(title, x, y);

        textSize(24);
        textFont(font40i);
        text(date, x, y + 30);

        fill(contentColour);
        textFont(font24);
        textSize(cFontSize);
          
        fill(contentColour);

        ArrayList s = new ArrayList();
        
        s = wordWrap(summary, w);
        String st = "" ;
        for (int i = 0; i <  s.size(); i++) 
            st += (String)s.get(i) + "\n";
          
        text(st, x, y + 75);
        
        h = (s.size()*(int)16) + 40 + 24 + 40 + 10;
    }  
}
