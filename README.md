# Assignment 1: Leeds Studio Projector Configuration System

## Overview

For this assignment, we were tasked with creating a program that would create a pixel configuration for the projector set up in Leeds Studio. This involved creating a mapping of the 6 projector screens pixel values to the physical space.

We chose to use Processing to develop the UI and store the pixel values in a JSON file upon completion of the user's mapping. Python was then used with various libraries (TODO: specify Python libraries). Below are further details about the UI, an explanation of the mapping of pixels to physical space, and a use case for these values in the form of a video processing module.

## Semi-Automatic Program: User Interface

In an attempt to align with the task's permission that the program could be semi-automatic, meaning requiring human input, we designed a User Interface in order to obtain the pixel to physical space mapping.

Through console prompts in the original Processing Sketch window, the user is instructed to click each of the available screens' top left and bottom right corner. These data points provide valuable information as they can be manipulated with each other to obtain each screen's height, width, and position.

The console also instructs the user to address the screens in order of left to right. In order to provide some clarity on this point, the number of the corresponding screen is displayed. For example, the far left screen will display 0, and the rightmost (in Leeds) will display 5.

After completing a screen by drawing its rectangle, the user must either press [y] to continue to the next rectangle or [n] to redraw the current rectangle in case of a mistake. The console reminds the user of these hotkeys throughout the workflow.

Finally, the user can press [s] to save the top left and bottom right corner pixel values to a JSON file when they finish mapping each screen and the screens display their corresponding numbers in ascending order from left to right.

### Click on the video thumbnail below to view a demo of the User Interface:

[![Watch the video](https://img.youtube.com/vi/YbrQDtN1v3M/maxresdefault.jpg)](https://youtu.be/YbrQDtN1v3M)

## File Output: Pixels to Physical Space Mapping

TODO: @Maansi include in this description

- Explanation of the file format
- Diagram of sample JSON points and where they exist in the physical space
- Final results of the mapping program (either screen_coords or screen_config, but preferably screen_coords since those numbers are taken directly from the projector)

## Use Case: Video Processing Module

TODO: @Cody include in description

- Explanation of how the Processing script output can be used to translate videos to be properly displayed across the projectors
- Identify various libraries used
- Talk about program being dynamic and not only specific to this projector set up
