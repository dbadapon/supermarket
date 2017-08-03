//
//  ARKitViewController.swift
//  Supermarket
//
//  Created by Xiuya Yao on 8/2/17.
//  Copyright © 2017 Team Triceratops. All rights reserved.
//

import UIKit
import ARKit
import SceneKit
import ModelIO
import SceneKit.ModelIO

class ARKitViewController: UIViewController {
    
    @IBOutlet weak var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        let configuration = ARWorldTrackingSessionConfiguration()
        configuration.planeDetection = .horizontal
        
        // runs view session
        // basic AR tracking
        sceneView.session.run(configuration)
    }
    
    // function that generate random float
    func randomFloat(min: Float, max: Float) -> Float {
        return (Float(arc4random()) / 0xFFFFFFFF) * (max - min) + min
    }
    
    @IBAction func dissmissARKit(_ sender: Any) {
        // stop running session here
        // figure out the code for it
        // sceneView.session.run(configuration)
        dismiss(animated: false, completion: nil)
    }
    
    @IBAction func addCube(_ sender: Any) {
        
        // cube will with 0.1^3 meters
        let cubeNode = SCNNode(geometry: SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0))
        // cube will appear 20 centimeters in front of camera
        // cube gets placed in place relative to root node not camera
        // line of code below would place cubes in same place everytime you tapped
        // cubeNode.position = SCNVector3(0, 0, -0.2)
        
        // code below will place cubes in one line
        // let zCoords = randomFloat(min: -2, max: -0.2)
        // print(String(zCoords))
        // cubeNode.position = SCNVector3(0, 0, zCoords)
        
        let cc = getCameraCoordinates(sceneView: sceneView)
        
        // place cube 0.2m in front of camera
        
        // place cube where camera is
        cubeNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        sceneView.scene.rootNode.addChildNode(cubeNode)
    }
    
    @IBAction func addCup(_ sender: Any) {
        let cupNode = SCNNode()
        
        let cc = getCameraCoordinates(sceneView: sceneView)
        cupNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        guard let virtualObjectScene = SCNScene(named: "cup.scn", inDirectory: "Models.scnassets/cup")
            else {
                return
        }
        
        // Notes: a virtual object can contain many nodes
        // code below adds all nodes into wrapper node
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        
        cupNode.addChildNode(wrapperNode)
        sceneView.scene.rootNode.addChildNode(cupNode)
    }
    
    @IBAction func addLamp(_ sender: Any) {
        let objectNode = SCNNode()
        
        let cc = getCameraCoordinates(sceneView: sceneView)
        objectNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        guard let virtualObjectScene = SCNScene(named: "lamp.scn", inDirectory: "Models.scnassets/lamp")
            else {
                return
        }
        
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        
        objectNode.addChildNode(wrapperNode)
        sceneView.scene.rootNode.addChildNode(objectNode)
    }
    
    @IBAction func addChair(_ sender: Any) {
        let objectNode = SCNNode()
        
        let cc = getCameraCoordinates(sceneView: sceneView)
        objectNode.position = SCNVector3(cc.x, cc.y, cc.z)
        
        guard let virtualObjectScene = SCNScene(named: "chair.scn", inDirectory: "Models.scnassets/chair")
            else {
                return
        }
        
        let wrapperNode = SCNNode()
        for child in virtualObjectScene.rootNode.childNodes {
            child.geometry?.firstMaterial?.lightingModel = .physicallyBased
            wrapperNode.addChildNode(child)
        }
        
        objectNode.addChildNode(wrapperNode)
        sceneView.scene.rootNode.addChildNode(objectNode)
    }
    
    // NOTES
    // use text.string to change string of text
    
    
    @IBAction func addObj(_ sender: Any) {
        let text = SCNText(string: "MOO", extrusionDepth: 1.0)
        text.firstMaterial?.diffuse.contents = UIColor.white
        // text.firstMaterial?.specular.contents = UIColor.orange
        text.font = UIFont(name: "Optima", size: 0.5)
        
        // text.containerFrame is a rectangle specifying the area in which SceneKit should lay out the text
        // text.containerFrame = CGRect(x: 0, y: 0, width: 30, height: 20)
        
        let textNode = SCNNode(geometry: text)
        // textNode.position = SCNVector3(-0.2 + x, -0.9 + delta, -1)
        //
        //        x += 0.12
        //
        // let cc = getCameraCoordinates(sceneView: sceneView)
        
        // place text where camera is
        // textNode.position = SCNVector3(cc.x, cc.y, cc.z)
        textNode.position = SCNVector3(-4.0, 0.0, 0.0)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
    
    
    
    struct myCameraCoordinates {
        var x = Float()
        var y = Float()
        var z = Float()
    }
    
    func getCameraCoordinates(sceneView: ARSCNView) -> myCameraCoordinates {
        let cameraTransform = sceneView.session.currentFrame?.camera.transform
        let cameraCoordinates = MDLTransform(matrix: cameraTransform!)
        
        var cc = myCameraCoordinates()
        cc.x = cameraCoordinates.translation.x
        cc.y = cameraCoordinates.translation.y
        cc.z = cameraCoordinates.translation.z
        
        return cc
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
