ArrayList wordWrap(String s, int maxWidth) {
    // Make an empty ArrayList
    ArrayList a = new ArrayList();
    float w = 0;    // Accumulate width of chars
    int i = 0;      // Count through chars
    int rememberSpace = 0; // Remember where the last space was
    // As long as we are not at the end of the String
    while (i < s.length ()) {
        // Current char
        char c = s.charAt(i);
        w += textWidth(c); // accumulate width
        if (c == ' ') rememberSpace = i; // Are we a blank space?
        if (w > maxWidth) {  // Have we reached the end of a line?
            String sub = s.substring(0, rememberSpace); // Make a substring
            // Chop off space at beginning
            if (sub.length() > 0 && sub.charAt(0) == ' ') sub = sub.substring(1, sub.length());
            // Add substring to the list
            a.add(sub);
            // Reset everything
            s = s.substring(rememberSpace, s.length());
            i = 0;
            w = 0;
        } 
        else {
            i++;  // Keep going!
        }
    }

    // Take care of the last remaining line
    if (s.length() > 0 && s.charAt(0) == ' ') s = s.substring(1, s.length());
    a.add(s);

    return a;
}
