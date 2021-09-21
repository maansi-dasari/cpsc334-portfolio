# Module 1 Task 2: Generative Art in Leeds Studio

## How to display the generative art in Leeds
1. Download the entire `processing_code` folder to the local computer.
2. Open `processing_code/projector_display/projector_display.pde` using Processing
3. Press the `Play` button in the upper left corner. After a couple seconds of loading time, the monitor screen should turn gray, and each of the projectors should turn a different color with rounded line stokes starting to appear on the screen.
4. Enjoy the art! Once you are finished, press `esc` on the keyboard to exit the program
5. You can restart the program from step 3 to generate a new set of randomized color palettes!

## How to change the display configuration
The display coordinates in screen_coords.json are currently set to match the display dimensions of the 6 projector screens in the Leeds Studio. If you want to change the number, location, or dimension of these screens which are used in the generative art program, you can write a new configuration to screen_coords.json by executing the following steps from Module 1 Part 1:
1. Open `processing_code/projector_setup/projector_setup.pde` using Processing
2. Press the `Play` button in the upper left corner. The entire screen, including the desktop and monitor, should turn white.
3. Starting with the leftmost screen, click on the top left and bottom right corners, in that order. After the screen has been (ideally) covered in a colored rectangle, press `y` on your keyboard to proceed or `n` to redraw the rectangle. You will not be able to come back and change the rectangle if you press `y`.
4. Continue this process so that the numbers on the rectangles appear in ascending order from left to right on the screens, pressing `y` to continue from rectangle to rectangle.
5. Once you are finished, and every projector screen has a number on it and the screen numbers are organized in ascending order, press `s`. This will save the x and y coordinates of the corners you pressed to a JSON file `screen_coords.json` in the `projector_code` directory.

## Code + Art Overview
This generative art display makes use of the screen coordinates stored in `processing_code/screen_coords.json` which are generated using the separate Processing program from module 1, task 1 (click [here](https://github.com/2021f-cpsc-334-a1-g1/a1/blob/main/README.md#file-output-pixels-to-physical-space-mapping) for more extensive documentation on this mapping). The art program loads in this information, and for each screen, creates a randomly generated "color palette" consisting of colors within a certain RGB range. The background of each screen reflects its range, and the initial circles that appear on the screen each have randomly generated RGB values that also fall within this range.

Each initial circle on the screen moves with a randomly generated initial velocity and "paints" a stroke of color on the screen as it moves. The painting circles bounce off of the edges of the screen, and when the lines meet each other, they collide and also exchange color values. In order to determine the new color values for each paint stroke in the collision, I added together both RGB values and then randomly split each channel between the two. By doing this, the overall color palette of the screen is generally preserved while allowing for the creation of new colors within the palette.

## Leeds Video Demo
Check out a ~30 second video of the art here: https://youtu.be/Jv_kpWuP3b8
