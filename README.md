# iOS Lab 4 - MarioKart

<img src="https://i.imgur.com/2rbj1yM.gif" width=150>&nbsp;<img src="https://i.imgur.com/shRDp0C.gif" width=150>&nbsp;<img src="https://i.imgur.com/j9lruic.gif" width=150>

### Overview
Tired of boring button-centric UI? Well...in iOS it's easy to implement interactive gestures and fun animations to give your UI some well deserved pop! In this lab you'll build an app that allows users to interact with characters from the iconic video game, Mario Kart, panning, scaling, rotating and then sending them zooming off the screen! 🏎

### User Stories
- **Required** (Demo project on **[master branch](https://github.com/codepath/MarioKart/tree/master)**)
   1. User can move karts around the screen using a pan gesture.
   1. User can adjust the size of a cart using a pinch gesture. 
   1. User can rotate a cart using a rotation gesture.
   1. User can double tap a kart to make it *zoom* (animate) off the screen.
   1. User can long press the background to reset the karts.
- **Bonus** (Demo Project on **[bonus_stories branch](https://github.com/codepath/MarioKart/tree/bonus_stories)**)
   1. User can use pinch and rotation gestures simultaneously.
   1. While panning, karts slightly increase in size to simulate being *picked up*.
   1. When a user double taps a kart it...
      1. Animates backwards slightly before *racing* off to simulate *winding up*.
      1. Pops a wheelie by rotating up and back down as it races off.
      1. After finishing racing off the screen, the kart fades back in it's original position.  
   1. User can triple tap the background to make all karts on the track *zoom* (animate) off at different speeds. 
   1. User can long press a cart to toggle between original and scaled up sizes with bouncing animations.
   
### New Topics

1. **Assets**
   1. Adding images to Assets folder
   1. Adding images from Media Library to Storyboard 
3. **Gesture Recognizers** 
   1. Objects
      - Pan, Pinch, Rotation, Tap, Long Press
   1. Actions
      - Creating gesture actions in IB, working with the sender 
   1. Properties
      - Location, rotation, scale 
   1. States
      - Began
4. **View Animations**
   1. Working with view animation methods.
      - Asynchronous execution
   1. Initial & destination states of animated views.
5. **View Properties**
   1. Resizing views in IB
   1. Adjusting view hierarchy in IB
   1. Content Modes
      - Aspect Fit
   1. Transform
      - Rotation, scale, identity
6. **Simulator**
   1. Working with gestures

### Bonus Topics
1. **Gesture Recognizers** 
   1. Properties
      - Translation 
   3. States
      - changed, ended
   4. Delegate
      - Setting gesture delegate in IB, delegate methods
1. **View Animations**
   1. Working with view animation methods.
      - completion handlers, animation settings
1. **View Properties**
   1. Programmatic wiew hierarchy modifications
   1. Subviews 
1. **Swift**
   1. Outlet collections
   1. Iterating through collections
         - Accessing item index while iterating
   1. Generating random numbers
