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
      // Store the centers for all the karts (where ever they are when the app launches)
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

   // Race the kart off the screen
   @IBAction func didDoubleTapKart(_ sender: UITapGestureRecognizer) {
      // Get a reference to the kart that was rotated
      let kartView = sender.view!
      // Kick off racing animation.
      // 1. Animate kart backwards wirh spring animation
      // 2. After backwards animation completes
      //   i. Pop a wheelie (rotate -30 deg and back down)
      //   ii. Race off the screen to the right (send the kart some fixed amout passed creen edge)
      //   iii. After race animation finishes, fade the kart back in it's orig. position.
      UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
         // Specify backwards animation end state: kart position slightly to the left
         kartView.center.x = kartView.center.x - 40
      }) { (Bool) in
         // Kick off "Pop a whelie" animation
         // Autorevere with 0 repeats will pitch the kart up and back down
         UIView.animate(withDuration: 0.3, delay: 0, options: [.autoreverse, .repeat], animations: {
            UIView.setAnimationRepeatCount(0)
            kartView.transform = CGAffineTransform(rotationAngle: CGFloat((-30) * Double.pi / 180))
         }, completion: { (Bool) in
            // Despite the autoreverse, the end state will always be what's specified
            // in the above animation block. In this case, back to roated -30deg
            // Set the rotation back to 0 after the pervious animation for a true
            // "up & down" effect
            kartView.transform = CGAffineTransform(rotationAngle: 0)
         })

         // Kick off "Race off animation with re-spawn"
         UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseIn, animations: {
            // Specify "race off" animation end state: kart position of the screen to the right
            kartView.center.x = kartView.center.x + 600
         }, completion: { (Bool) in
            // After racing off animation has finished...
            // Set the initial state of the view to be transparent (aplha = 0)
            kartView.alpha = 0
            // Move the (transparent) kart back to it's original position
            // Use the kart's tag to get the correct center from the original centers array
            kartView.center = self.originalKartCenters[kartView.tag]
            // Kick off alpha fade in of kart
            UIView.animate(withDuration: 0.4, animations: {
               kartView.alpha = 1
            })
         })
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

   @IBAction func didTrippleTabBackground(_ sender: UITapGestureRecognizer) {
      print("tripple tap recognized")
      for kartView in view.subviews {
         // If view is the background view (tag = 10), leave the view alone
         if kartView.tag == 10 { continue }
         // Kick off race animations
         UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0, options: .curveEaseOut, animations: {
            // Specify backwards animation end state: kart position slightly to the left
            kartView.center.x = kartView.center.x - 40
         }) { (Bool) in
            // Kick off "Pop a whelie" animation
            // Autorevere with 0 repeats will pitch the kart up and back down
            UIView.animate(withDuration: 0.3, delay: 0, options: [.autoreverse, .repeat], animations: {
               UIView.setAnimationRepeatCount(0)
               kartView.transform = CGAffineTransform(rotationAngle: CGFloat((-30) * Double.pi / 180))
            }, completion: { (Bool) in
               // Despite the autoreverse, the end state will always be what's specified
               // in the above animation block. In this case, back to roated -30deg
               // Set the rotation back to 0 after the pervious animation for a true
               // "up & down" effect
               kartView.transform = CGAffineTransform(rotationAngle: 0)
            })

            // Kick off "Race off animation with re-spawn"
            // Get a random number between 0.1 and 1 to use for varying kart speeds
            let randomDuration = Double(Float.random(in: 0.5 ... 1.5))
            UIView.animate(withDuration: randomDuration, delay: 0, options: .curveEaseIn, animations: {
               // Specify "race off" animation end state: kart position of the screen to the right
               kartView.center.x = kartView.center.x + 600
            }, completion: { (Bool) in
               // After racing off animation has finished...
               // Set the initial state of the view to be transparent (aplha = 0)
               kartView.alpha = 0
               // Move the (transparent) kart back to it's original position
               // Use the kart's tag to get the correct center from the original centers array
               kartView.center = self.originalKartCenters[kartView.tag]
               // Kick off alpha fade in of kart
               UIView.animate(withDuration: 0.4, animations: {
                  kartView.alpha = 1
               })
            })
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

