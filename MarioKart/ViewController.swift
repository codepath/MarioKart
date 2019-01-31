//
//  ViewController.swift
//  Mario Cart
//
//  Created by Charles Hieger on 1/25/19.
//  Copyright © 2019 Charles Hieger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

   // Outlets for each kart
   @IBOutlet weak var kartView0: UIImageView!
   @IBOutlet weak var kartView1: UIImageView!
   @IBOutlet weak var kartView2: UIImageView!

   // A property that will be used to store all the kart's original positions
   // Initialized as an empty array
   var originalKartCenters = [CGPoint]()

   // This method is called when the view controller has awakened and is finished
   // setting up it's views
   override func viewDidLoad() {
      super.viewDidLoad()

      originalKartCenters = [kartView0.center,
                             kartView1.center,
                             kartView2.center]
   }

   // Move the kart's position as the user pans (refactored using translation)
   @IBAction func didPanKart(_ sender: UIPanGestureRecognizer) {
      // Get the current translation value from the gesture recognizer
      let translation = sender.translation(in: view)
      // Get a reference to the kart that was panned
      let kartView = sender.view!
      // If this is the beginning of the gesture recognition event, do the following
      // The begin state is called only once per recognition event
      if sender.state == .began {
         // Bring the kart view in front of the other karts
         view.bringSubviewToFront(kartView)
         // Initiate a spring animation sequence and specify the animation"s
         // duration, spring settings and animation options
         UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            // update the kart's transform property with and absolute sacle: 2x
            kartView.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
            // Since no following animations, completion handler is set to nil
         }, completion: nil)
         // If this is the gesture recognition event is in progress, do the following
         // The changed state is called continuously as the gesture event is in progress
      } else if sender.state == .changed {
         // Update the kart's position by adding and assigning the translation
         // from the gesture recognizer
         kartView.center.x += translation.x
         kartView.center.y += translation.y
         // reset the gesture recognizer's scale in preperation for the next call
         sender.setTranslation(CGPoint(x: 0, y: 0), in: view)
      } else if sender.state == .ended {
         // Initiate a spring animation sequence and specify the animation"s
         // duration, spring settings and animation options
         UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            // update the kart's transform property with and absolute sacle: 2x
            kartView.transform = CGAffineTransform(scaleX: 1, y: 1)
            // no following animations so completion handler is set to nil
         }, completion: nil)
      }
   }

   // Scale the kart as the user pinches
   @IBAction func didPinchKart(_ sender: UIPinchGestureRecognizer) {
      // Get the current scale value from the gesture recognizer
      let scale = sender.scale
      // print("scale: \(scale)")
      // Get a reference to the kart that was pinched
      let kartView = sender.view!
      // update the kart's transform property with the scale from the gesture
      kartView.transform = kartView.transform.scaledBy(x: scale, y: scale)
      // reset the gesture recognizer's scale in preperation for the next call
      sender.scale = 1
   }

   // Rotate the cart
   @IBAction func didRotateKart(_ sender: UIRotationGestureRecognizer) {
      // Get the current scale value from the gesture recognizer
      let rotation = sender.rotation
      // print("rotation: \(rotation)")
      // Get a reference to the kart that was rotated
      let kartView = sender.view!
      // update the kart's transform property with the rotation from the gesture
      kartView.transform = kartView.transform.rotated(by: rotation)
      // reset the gesture recognizer's rotation in preperation for the next call
      sender.rotation = 0
   }

   // Zoom the kart
   @IBAction func didDoubleTapKart(_ sender: UITapGestureRecognizer) {
      // Get a reference to the kart that was rotated
      let kartView = sender.view!
      // Initiate an animation sequence and specify the animation duration
      UIView.animate(withDuration: 0.6) {
         // Specify the animation end state:
         // - a shift in the kart's horizontal poition by the width of the screen
         kartView.center.x = kartView.center.x + self.view.frame.width
      }
   }

   @IBAction func didLongPressBackground(_ sender: UILongPressGestureRecognizer) {
      // Do the following only in the beginning of a recognition event
      // Beginning state only called once per recognition event
      if sender.state == .began {
         // Initiate an animation sequence and specify the animation duration
         UIView.animate(withDuration: 0.4) {
            // Specify the animation end state:
            // 1. Return all kart's to their original transformation state (un-transformed)
            self.kartView0.transform = CGAffineTransform.identity
            self.kartView1.transform = CGAffineTransform.identity
            self.kartView2.transform = CGAffineTransform.identity

            // 2. Return all kart's to thier original positions
            self.kartView0.center = self.originalKartCenters[0]
            self.kartView1.center = self.originalKartCenters[1]
            self.kartView2.center = self.originalKartCenters[2]
         }
      }
   }

   // Allow simultaneous gesture recognition
   // In this case, allow only pinch and rotation.
   // Set the delegate on each pan gesture recognizer if panning is desired in
   // addition to pinch and rotate
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      // Yes, simultaneous gestures should be allowed
      return true
   }
}

