//
//  ViewController.swift
//  Whack a jellyfish
//
//  Created by Rayan Slim on 2017-08-13.
//  Copyright © 2017 Rayan Slim. All rights reserved.
//

import UIKit
import ARKit
class ViewController: UIViewController {

    @IBOutlet weak var SceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.SceneView.debugOptions = [ARSCNDebugOptions.showWorldOrigin, ARSCNDebugOptions.showFeaturePoints]
        self.SceneView.session.run(configuration)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        self.SceneView.addGestureRecognizer(tapGestureRecognizer)
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func play(_ sender: Any) {
        self.addNode()
    }
    
    @IBAction func reset(_ sender: Any) {
    }
    

    
    func addNode() {
        let node = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.1/2))
        node.position = SCNVector3(0,0,-0.5)
        node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        self.SceneView.scene.rootNode.addChildNode(node)
        
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            let results = hitTest.first!
            let geometry = results.node.geometry
            print(geometry)
            let distanceFromBox = distance(from: results.node.position)
            print("the distance from the box is \(distanceFromBox)")
            
            if distanceFromBox < 2 {
                let alert = UIAlertController(title: "Alert", message: "Tapped the mystery box", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Open", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: "Alert", message: "You are too far from the mystery box", preferredStyle: UIAlertControllerStyle.alert)
                alert.addAction(UIAlertAction(title: "Open", style: UIAlertActionStyle.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }

        }
    }
    
    func distance(from vector: SCNVector3) -> Float {
        let distanceX = (SceneView.pointOfView?.position.x)! - vector.x
        let distanceY = (SceneView.pointOfView?.position.y)! - vector.y
        let distanceZ = (SceneView.pointOfView?.position.z)! - vector.z
        
        return sqrtf((distanceX * distanceX) + (distanceY * distanceY) + (distanceZ * distanceZ))
    }
}

