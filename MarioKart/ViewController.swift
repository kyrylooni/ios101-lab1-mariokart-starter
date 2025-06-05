//
//  ViewController.swift
//  Mario Cart
//
//  Created by Charles Hieger on 1/25/19.
//  Copyright © 2019 Charles Hieger. All rights reserved.
//

import UIKit

class ViewController: UIViewController,
                      UIGestureRecognizerDelegate {
  
  // Bowser
  @IBOutlet weak var kartView0: UIImageView!
  // Mario
  @IBOutlet weak var kartView1: UIImageView!
  // Toad
  @IBOutlet weak var kartView2: UIImageView!
  
  // Keeps track of the original position of the karts when the view is initially loaded
  private var originalKartCenters = [CGPoint]()
  
  // Called when the view controller has awakened and is finished
  // setting up it's views
  override func viewDidLoad() {
    super.viewDidLoad()
    
    originalKartCenters = [kartView0.center,
                           kartView1.center,
                           kartView2.center]
  }
  
  //  Called when user double-taps a kart
    @IBAction func didDoubleTapKart(_ sender: UITapGestureRecognizer) {
        guard let kart = sender.view else { return }

        // Move the kart past the right edge
        translate(kart: kart, by: view.frame.width * 1.5) {
            // After it's off-screen, move it back to its original position
            self.translate(kart: kart, by: -self.view.frame.width * 1.5)
        }
    }
  
  private func translate(kart: UIView?,
                         by xPosition: Double,
                         animationDuration: Double = 0.6,
                         completion: (() -> Void)? = nil) {
    guard let kart = kart else { return }
    UIView.animateKeyframes(withDuration: animationDuration, delay: 0.0) {
      kart.center.x = kart.center.x + xPosition
    } completion: { finished in
      completion?()
    }
  }
  
  // Called when the user rotates a kart
    @IBAction func didRotateKart(_ sender: UIRotationGestureRecognizer) {
        rotate(kart: sender.view, gestureRecognizer: sender)
    }
  
  private func rotate(kart: UIView?,
                      gestureRecognizer: UIRotationGestureRecognizer) {
    guard let kart = kart else { return }
    kart.transform = kart.transform.rotated(by: gestureRecognizer.rotation)
    gestureRecognizer.rotation = 0
  }
  
  // Called when the user pinches a kart
    @IBAction func didPinchKart(_ sender: UIPinchGestureRecognizer) {
        scale(kart: sender.view, gestureRecognizer: sender)
  }
  
  private func scale(kart: UIView?,
                     gestureRecognizer: UIPinchGestureRecognizer) {
    guard let kart = kart else { return }
    kart.transform = kart.transform.scaledBy(x: gestureRecognizer.scale,
                                             y: gestureRecognizer.scale)
    gestureRecognizer.scale = 1
  }
  
  // Called when the user pans on a kart
  @IBAction func didPanKart(_ sender: UIPanGestureRecognizer) {
    moveKart(using: sender)
  }
  
  // Exercise 4: Implement the `moveKart` function to move the kart based on the
  // location of the location of the gesture in the view
    private func moveKart(using gestureRecognizer: UIPanGestureRecognizer) {
        guard let kart = gestureRecognizer.view else { return }

        // Get the translation (movement) since the last update
        let translation = gestureRecognizer.translation(in: kart.superview)

        // Update the kart's position by adding the translation to its current center
        kart.center = CGPoint(x: kart.center.x + translation.x,
                              y: kart.center.y + translation.y)

        // Reset the translation to zero so it’s relative for the next call
        gestureRecognizer.setTranslation(.zero, in: kart.superview)
    }
  
  @IBAction func didLongPressBackground(_ sender: UILongPressGestureRecognizer) {
    if sender.state == .began {
      resetKarts()
    }
  }
  
    @IBOutlet weak var kart1: UIImageView!
    @IBOutlet weak var kart2: UIImageView!

    // To store initial positions
    var kart1StartCenter: CGPoint!
    var kart2StartCenter: CGPoint!

  // Exercise 5: Implement `resetKarts` to reset the size and positioning of the karts
    private func resetKarts() {
      UIView.animate(withDuration: 0.4) { // these changes should occur over the duration of 0.4 seconds
        // reset the transformations for the karts to their original state
        self.kartView0.transform = .identity
        self.kartView1.transform = .identity
        self.kartView2.transform = .identity
        // reset the positions of the karts to their initial positions
        self.kartView0.center = self.originalKartCenters[0]
        self.kartView1.center = self.originalKartCenters[1]
        self.kartView2.center = self.originalKartCenters[2]
      }
    }
  // Called whenever the view becomes visible on the screen
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        runStartingAnimationsOneByOne {
            self.raceKartsWithRandomizedSpeed()
        }
    }
  private func getKartReadyToRace(kart: UIImageView,
                                  completion: (() -> Void)? = nil) {
    UIView.animateKeyframes(
      withDuration: 0.6,
      delay: 0.0,
      animations: {
        kart.center.x = kart.center.x + 20
      },
      completion: { _ in
        completion?()
      })
  }
  
  // Exercise 7: Animate all karts all at once as if they were getting ready for a race
  // Tip: Use `getKartReadyToRace`
    private func runStartingAnimationsAllAtOnce() {
        getKartReadyToRace(kart: kartView0)
        getKartReadyToRace(kart: kartView1)
        getKartReadyToRace(kart: kartView2)
    }
  // Exercise 8: Animate all karts one-by-one
  // Tip: Use `getKartReadyToRace` and its completion closure
    private func runStartingAnimationsOneByOne(completion: (() -> Void)? = nil) {
        getKartReadyToRace(kart: kartView0) { // First kart
            self.getKartReadyToRace(kart: self.kartView1) { // Then second kart
                self.getKartReadyToRace(kart: self.kartView2) { // Then third kart
                    completion?() // Optional: execute a follow-up action after all karts animate
                }
            }
        }
    }
  // Exercise 9: Have the karts race all at once to the finish line!
  // Tip: Use the `translate` function above
    private func raceKartsWithSameSpeed() {
      translate(kart: kartView0, by: view.frame.width)
      translate(kart: kartView1, by: view.frame.width)
      translate(kart: kartView2, by: view.frame.width)
    }
  
  // Exercise 10: Have the karts race all at once to the finish line!
  // Tip: Use the `translate` function above
    private func raceKartsWithRandomizedSpeed() {
        let kartView0Speed = Double.random(in: 0.5...5.0)
        translate(kart: kartView0, by: view.frame.width, animationDuration: kartView0Speed)

        let kartView1Speed = Double.random(in: 0.5...5.0)
        translate(kart: kartView1, by: view.frame.width, animationDuration: kartView1Speed)

        let kartView2Speed = Double.random(in: 0.5...5.0)
        translate(kart: kartView2, by: view.frame.width, animationDuration: kartView2Speed)
    }
}

