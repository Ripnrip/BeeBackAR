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
    

    @IBAction func addPinkBox(_ sender: Any) {
        addPinkNode()
    }
    
    func addNode() {
        //// General Declarations
         UIGraphicsBeginImageContextWithOptions(self.SceneView.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        
        //// Image Declarations
        let beeBackAR = UIImage(named: "BeeBackAR.png")!
        
        //// Picture Drawing
        let picturePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 50, height: 50))
        context.saveGState()
        picturePath.addClip()
        context.translateBy(x: 0, y: 0)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -beeBackAR.size.height)
        context.draw(beeBackAR.cgImage!, in: CGRect(x: 0, y: 0, width: beeBackAR.size.width, height: beeBackAR.size.height))
        context.restoreGState()
        
        let scnShape = SCNShape(path: picturePath, extrusionDepth: 0.2)
        let node = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.1/2))
        //node.geometry = scnShape
        node.position = SCNVector3(0,0,-0.5)
        
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "BeeBackAR.png")!
        //node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        self.SceneView.tag = 0
        self.SceneView.scene.rootNode.addChildNode(node)
        
    }
    
    func addPinkNode(){
        //// General Declarations
        UIGraphicsBeginImageContextWithOptions(self.SceneView.frame.size, false, 0.0)
        let context = UIGraphicsGetCurrentContext()!
        
        
        //// Image Declarations
        let beeBackAR = UIImage(named: "LogoRed.png")!
        
        //// Picture Drawing
        let picturePath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: 50, height: 50))
        context.saveGState()
        picturePath.addClip()
        context.translateBy(x: 0, y: 0)
        context.scaleBy(x: 1, y: -1)
        context.translateBy(x: 0, y: -beeBackAR.size.height)
        context.draw(beeBackAR.cgImage!, in: CGRect(x: 0, y: 0, width: beeBackAR.size.width, height: beeBackAR.size.height))
        context.restoreGState()
        
        let scnShape = SCNShape(path: picturePath, extrusionDepth: 0.2)
        let node = SCNNode(geometry: SCNBox(width: 0.2, height: 0.2, length: 0.2, chamferRadius: 0.1/2))
        //node.geometry = scnShape
        node.position = SCNVector3(0,0,1.0)
        
        node.geometry?.firstMaterial?.diffuse.contents = UIImage(named: "LogoRed.png")!
        //node.geometry?.firstMaterial?.diffuse.contents = UIColor.orange
        self.SceneView.tag = 1
        self.SceneView.scene.rootNode.addChildNode(node)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        let sceneViewTappedOn = sender.view as! SCNView
        let touchCoordinates = sender.location(in: sceneViewTappedOn)
        let hitTest = sceneViewTappedOn.hitTest(touchCoordinates)
        if hitTest.isEmpty {
            print("didn't touch anything")
        } else {
            if sceneViewTappedOn.tag == 1 {
                //show youtube ad
                UIApplication.shared.openURL(URL(string: "https://www.youtube.com/watch?v=k6UF2uZprYQ")!)
                return
            }
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

