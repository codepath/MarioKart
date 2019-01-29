//
//  ViewController.swift
//  Mario Cart
//
//  Created by Charles Hieger on 1/25/19.
//  Copyright © 2019 Charles Hieger. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

   override func viewDidLoad() {
      super.viewDidLoad()

   }

   // Pan the cart
   @IBAction func didPanCart(_ sender: UIPanGestureRecognizer) {
      let kartView = sender.view
      view.bringSubviewToFront(kartView!)
      let location = sender.location(in: view)
      // print("Location: x: \(location.x), y: \(location.y)")
      kartView?.center = location
   }


   @IBAction func didPanKart(_ sender: UIPanGestureRecognizer) {

      guard let kartView = sender.view else {return}
      view.bringSubviewToFront(kartView)
      let translation = sender.translation(in: view)
      kartView.bringSubviewToFront(view)
      let kartOrigCenter = kartView.center
      kartView.center.x = kartOrigCenter.x + translation.x
      kartView.center.y = kartOrigCenter.y + translation.y
      sender.setTranslation(CGPoint(x: 0, y: 0), in: view)

   }

   // Scale the cart
   @IBAction func didPinchCart(_ sender: UIPinchGestureRecognizer) {
      let scale = sender.scale
      // print("scale: \(scale)")
      let cart = sender.view
      cart?.transform = (cart?.transform.scaledBy(x: scale, y: scale))!
      sender.scale = 1
   }

   // Rotate the cart
   @IBAction func didRotateCart(_ sender: UIRotationGestureRecognizer) {
      let rotation = sender.rotation
      // print("rotation: \(rotation)")
      let cart = sender.view
      cart?.transform = (cart?.transform.rotated(by: rotation))!
      sender.rotation = 0
   }

   func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
      //print("recognize simulatneous delegate called")
      return true
   }

   // Zoom the kart

}

