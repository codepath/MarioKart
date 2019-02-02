//
//  ViewController.swift
//  Mario Cart
//
//  Created by Charles Hieger on 1/25/19.
//  Copyright © 2019 Charles Hieger. All rights reserved.
//

import UIKit
import FLAnimatedImage

class ViewController: UIViewController, UIGestureRecognizerDelegate {

   //---OUTLETS---
   // Outlets for each kart
   @IBOutlet weak var kartView0: UIImageView!
   @IBOutlet weak var kartView1: UIImageView!
   @IBOutlet weak var kartView2: UIImageView!

   // semi transparent black view in back of winer card sequence
   var backingView: UIView!

   // Outlet for floating cloud animated gif
   @IBOutlet weak var cloudAnimatedView: FLAnimatedImageView!

   //---VIEW POSITIONS---
   // A property that will be used to store all the kart's original positions
   // Initialized as an empty array
   var originalKartCenters = [CGPoint]()
   // A property to store our animated cloud center
   // Initialize with (0,0) (.zero) to avoid dealing with optionals down the road

   var cloudDownCenter = CGPoint.zero
   var cloudUpCenter = CGPoint.zero
   // This method is called when the view controller has awakened and is finished
   // setting up it's views

   //---MISC. PROPERTIES
   // The animated gif image. Needed for setting and resetting animated image view
   var cloudAnimatedImage: FLAnimatedImage?

   override func viewDidLoad() {
      super.viewDidLoad()
      // Store the centers for all the karts (where ever they are when the app launches)
      originalKartCenters = [kartView0.center,
                             kartView1.center,
                             kartView2.center]

      // Store the original center of the animated cloud as it appears on the storyboard
      // This will be the position we'll use to drop the cloud when we want it in view
      cloudDownCenter = cloudAnimatedView.center

      // Position our animated cloud image view above the screen so we can drop in later
      // Store our position for when the cloud is up and above the screen
      // The horizontal x position willbe the same as when down
      cloudUpCenter.x = cloudDownCenter.x
      // The top of the screen is y=0 so the center will need to be a negative number
      // that is enough to get the entire view above the screen as to not show
      cloudUpCenter.y = 0 - cloudAnimatedView.frame.size.height / 2
      // Position the cloud in the "up" position
      cloudAnimatedView.center = cloudUpCenter

      // SETUP THE ANIMATED GIF
      // Locate the path to the animated gif (by name and file type)
      let path = Bundle.main.path(forResource: "cloudAnimated", ofType: "gif")!
      // get the url of the gif using it's path
      let url = URL(fileURLWithPath: path)
      // get the actual image data using the url
      // Note, this can throw an error and the proper way to handle would be try, do, catch
      // However, for this example, we're not going to handle any potential errors
      let gifData = try! Data(contentsOf: url)
      // Create an animated image from the data (note: ignoring potential errors from try)
      let animatedImage = try! FLAnimatedImage(animatedGIFData: gifData)
      // Store the animated image for later use
      cloudAnimatedImage = animatedImage
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
         UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
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

      if sender.state == .ended {
         UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            // update the kart's transform property with and absolute sacle: 2x
            kartView.transform = CGAffineTransform.identity
            // no following animations so completion handler is set to nil
         }, completion: nil)
      }
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

      if sender.state == .ended {
         UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 1, options: .curveEaseIn, animations: {
            // update the kart's transform property with and absolute sacle: 2x
            kartView.transform = CGAffineTransform.identity
            // no following animations so completion handler is set to nil
         }, completion: nil)
      }
   }

   // Race the kart off the screen
   @IBAction func didDoubleTapKart(_ sender: UITapGestureRecognizer) {
      // Get a reference to the kart that was rotated
      let kartView = sender.view!
      raceOffScreen(with: [kartView])
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

   // When user tripple taps the BG, race all karts off the screen
   // Drop in the animated cloud with stop light and begin race when gif animation completes
   @IBAction func didTrippleTabBackground(_ sender: UITapGestureRecognizer) {
      // Reset the cloud animated image view
      cloudAnimatedView.animatedImage = nil
      // Load the animated image into the image view we created in the storyboard
      cloudAnimatedView.animatedImage = cloudAnimatedImage
      // Stop cloud gif animation (will freeze first frame) we'll start it once the cloud
      // is in it's down position
      cloudAnimatedView.stopAnimating()
      // Kick off the cloud dropping animation
      UIView.animate(withDuration: 0.3 , delay: 0, options: .curveEaseOut, animations: {
         // Drop the animated light ontho the screen
         self.cloudAnimatedView.center = self.cloudDownCenter
      }) { (Bool) in
         // Start the cloud float animation
         UIView.animate(withDuration: 0.8, delay: 0, options: [.autoreverse, .repeat], animations: {
            UIView.setAnimationRepeatCount(2.5)
            self.cloudAnimatedView.center.y -= 40
         }, completion: nil)
         // Start the Cloud's gif animation
         self.cloudAnimatedView.startAnimating()
         // When the gif animation finishes, stop the cloud animation and start
         // the race animation
         self.cloudAnimatedView.loopCompletionBlock = {_ in
            // Stop the cloud gif animation on the last frame
            self.cloudAnimatedView.stopAnimating()
            // Loop through all of the kart views and initiate their race sequence
            var kartViews = [UIView]()
            for kartView in self.view.subviews {
               // If view is NOT a kart view (tag < 0) leave the view alone
               // Note: set all non-kart views to (-1)
               if kartView.tag < 0 { continue }
               kartViews.append(kartView)
            }
            // Generate random kart finishers sequence (winner is position 0)
            let finishingSequence = kartViews.shuffled()
            print("The winner is\(finishingSequence[0].tag)")
            // Kick off race animations
            self.raceOffScreen(with: finishingSequence)
         }
      }
   }

   // Wrap up race off screen animation sequence for reuse
   // Currently used in touble tab single race and tripple tap BG all race
   func raceOffScreen(with kartViews: [UIView]) {
      // for each kart do the following... (capture the index for the karts to use with speed calc)
      for (index, kartView) in kartViews.enumerated() {
         // Kick off racing animation.
         // 1. Animate kart backwards wirh spring animation
         // 2. After backwards animation completes
         //   i. Pop a wheelie (rotate -30 deg and back down)
         //   ii. Race off the screen to the right (send the kart some fixed amout passed creen edge)
         //   iii. After race animation finishes, fade the kart back in it's orig. position.
         UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 10, options: [.curveEaseIn], animations: {
            // Specify backwards animation end state: kart position slightly to the left
            kartView.center.x = kartView.center.x - 30
         }) { (Bool) in
            // Kick off "Pop a whelie" animation
            UIView.animate(withDuration: 0.3, delay: 0, options: [], animations: {
               // Rotate the kart up 30 deg
               kartView.transform = CGAffineTransform(rotationAngle: CGFloat((-30) * Double.pi / 180))
            }, completion: { (Bool) in
               // Rotate the kart back down to 0 deg
               UIView.animate(withDuration: 0.3, animations: {
                  kartView.transform = CGAffineTransform(rotationAngle: 0)
               })
            })

            // Min duration of finishing the race (The fastest any kart will go)
            let minDuration = 0.5
            // Multiply duration by kart's position in finishing sequence (first kart is winner)
            let duration = minDuration * Double(index + 1)
            //print("random duration: \(randomDuration)")
            UIView.animate(withDuration: duration, delay: 0, options: .curveEaseIn, animations: {
               // Specify "race off" animation end state: kart position of the screen to the right
               kartView.center.x = self.view.frame.width + 200
            }, completion: { (Bool) in
               // If this is the last kart to finish

               // If this is a muti kart race sequence, queue the winner sequence
               if kartViews.count > 1 && index == kartViews.count - 1 {
                  // Create the winner sequence bg view
                  // size and position it to to cover the entire screen
                  let backingView = UIView(frame: self.view.frame)
                  // give it a black bg color and make it slightly transparent
                  backingView.backgroundColor = UIColor.black
                  backingView.alpha = 0

                  // Create the winner card
                  let winnerCardView = UIView()
                  winnerCardView.isUserInteractionEnabled = true
                  winnerCardView.frame.size.width = backingView.frame.size.width * 0.7
                  winnerCardView.frame.size.height = backingView.frame.size.height * 0.5
                  // Position card above screen
                  winnerCardView.center.x = backingView.center.x
                  winnerCardView.center.y = 0 - winnerCardView.frame.size.height / 2
                  winnerCardView.layer.cornerRadius = 30
                  winnerCardView.backgroundColor = UIColor.white
                  let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapWinnerCard(_:)))
                  tapGesture.numberOfTapsRequired = 1
                  winnerCardView.addGestureRecognizer(tapGesture)

                  // Greate animated winner view
                  // SETUP THE ANIMATED GIF
                  // Locate the path to the animated gif (by name and file type)
                  let path = Bundle.main.path(forResource: "mk_winner_\(kartViews[0].tag)", ofType: "gif")!
                  // get the url of the gif using it's path
                  let url = URL(fileURLWithPath: path)
                  // get the actual image data using the url
                  // Note, this can throw an error and the proper way to handle would be try, do, catch
                  // However, for this example, we're not going to handle any potential errors
                  let gifData = try! Data(contentsOf: url)
                  // Create an animated image from the data (note: ignoring potential errors from try)
                  let animatedImage = FLAnimatedImage(animatedGIFData: gifData)
                  // Store the animated image for later use
                  let animatedWinnerView = FLAnimatedImageView()
                  animatedWinnerView.frame.size.width = winnerCardView.frame.size.width * 0.8
                  animatedWinnerView.frame.size.height = animatedWinnerView.frame.size.width
                  //animatedWinnerView.frame = winnerCardView.bounds
                  // animatedWinnerView.backgroundColor = UIColor.blue
                  animatedWinnerView.center.x = winnerCardView.frame.size.width / 2
                  animatedWinnerView.center.y = winnerCardView.frame.size.height / 3 * 2
                  animatedWinnerView.contentMode = .scaleAspectFit
                  animatedWinnerView.clipsToBounds = true
                  animatedWinnerView.animatedImage = animatedImage
                  winnerCardView.addSubview(animatedWinnerView)

                  // Create 1st Place text view
                  let label = UILabel()
                  label.frame.size.width = 200
                  label.frame.size.height = 200
                  label.center.x = winnerCardView.frame.size.width / 2
                  label.center.y = winnerCardView.frame.size.height / 4.5
                  //label.lineBreakMode = .byWordWrapping
                  //label.numberOfLines = 2
                  label.textColor = UIColor.black
                  label.font = UIFont.systemFont(ofSize: 100, weight: .thin)
                  label.text = "🏆"
                  label.textAlignment = .center
                  //label.backgroundColor = UIColor.red
                  winnerCardView.addSubview(label)

                  // Add backing and winner card views to view hierarchy
                  self.backingView = backingView
                  self.view.addSubview(self.backingView)
                  self.view.addSubview(winnerCardView)
                  UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                     winnerCardView.center = backingView.center
                     self.backingView.alpha = 0.8
                     self.cloudAnimatedView.center = self.cloudUpCenter
                  }, completion: { (Bool) in

                  })
               } else if index == kartViews.count - 1 {
                  // After racing off animation has finished...
                  // Set the initial state of the view to be transparent (aplha = 0)
                  print("This is the last kart")
                  kartView.alpha = 0
                  // Move the (transparent) kart back to it's original position
                  // Use the kart's tag to get the correct center from the original centers array
                  kartView.center = self.originalKartCenters[kartView.tag]
                  // Kick off alpha fade in of kart + move cloud to up position
                  UIView.animate(withDuration: 0.4, animations: {
                     // Fade in the karts
                     kartView.alpha = 1
                     // Move the cloud to the up position
                  })
               }
            })
         }
      }
   }

   @objc func didTapWinnerCard(_ sender: UITapGestureRecognizer) {
      let winnerCardView = sender.view!
      UIView.animate(withDuration: 0.4, delay: 0, options: .curveEaseIn, animations: {
         winnerCardView.frame.origin.y = self.view.frame.size.height
         self.backingView.alpha = 0
      }, completion: { (Bool) in
         winnerCardView.removeFromSuperview()
         self.backingView.removeFromSuperview()

         // Set karts off to the left so they can racinto position
         self.kartView0.center.x = self.originalKartCenters[0].x - self.view.frame.size.width - 40
         self.kartView1.center.x = self.originalKartCenters[1].x - self.view.frame.size.width - 40
         self.kartView2.center.x = self.originalKartCenters[2].x - self.view.frame.size.width - 40

         self.kartView0.center.y = self.originalKartCenters[0].y
         self.kartView1.center.y = self.originalKartCenters[1].y
         self.kartView2.center.y = self.originalKartCenters[2].y
         // Reset Karts
         UIView.animate(withDuration: 0.4) {
            // Specify the animation end state:
            // Return all kart's to thier original positions
            self.kartView0.center = self.originalKartCenters[0]
            self.kartView1.center = self.originalKartCenters[1]
            self.kartView2.center = self.originalKartCenters[2]
         }
      })
   }

   // Allow simultaneous gesture recognition
   // In this case, allow only pinch and rotation.
   // Set the delegate on each pan gesture recognizer if panning is desired in
   // addition to pinch and rotate
   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      // Yes, simultaneous gestures should be allowed
      return true
   }

   /*
    func finishingSequence(for kartViews: [UIView]) ->[UIView] {
    var finishingSequence = [UIView]()
    var kartFinishingSequence = kartViews.shuffled()
    var kartFinishingTags = [Int]()
    for kartView in kartFinishingSequence {
    kartFinishingTags.append(kartView.tag)
    }
    print("Kart finishing tags: \(kartFinishingTags)")
    }
    */
   /*
    func generateRaceResults(for kartViews: [UIView]) {
    var winnerTag = 0
    // create 3 unique random numbers between 1-3
    var raceResults = [Int]()
    var currentResult = 0
    var previousResult = 0
    for kartView in kartViews {
    //let key = kartView.tag
    while currentResult == previousResult {
    currentResult = Int.random(in: 1 ... kartViews.count)
    }
    raceResults.append(currentResult)
    if currentResult == 1 {
    winnerTag = kartView.tag
    }
    previousResult = currentResult
    }
    print("race results: \(raceResults)")
    print("winner tag: \(winnerTag)")
    }
    */
}

