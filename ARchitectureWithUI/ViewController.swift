//
//  ViewController.swift
//  ARchitectureWithUI
//
//  Created by An Nguyen on 6/11/18.
//  Copyright © 2018 An Nguyen. All rights reserved.
//
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate { 
    //Mark: Outlets
    @IBOutlet weak var ARSCNView: ARSCNView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    
    //Mark: Variables
    var modelNode: SCNNode?
    var currentAngleY: Float = 0.0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Set the view's delegate
        sceneView.delegate = self
        
        //Display arkit stat
        sceneView.showsStatistics = true
        
        //Create a new scene
        let scene = SCNScene()
        
        sceneView.scene = scene

        statusLabel.layer.cornerRadius = 20.0
        statusLabel.layer.masksToBounds = true
        statusLabel.adjustsFontForContentSizeCategory = true

    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        
        // Run the view's session
        sceneView.session.run(configuration)
        //Show yellow feature points
        sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        sceneView.addGestureRecognizer(gestureRecognizer)
        let rotateGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(rotate))
        sceneView.addGestureRecognizer(rotateGestureRecognizer)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Add button, hitTest the middle point on device screen. Then call addModel.
    @IBAction func AddButton(_ sender: UIButton) {
        print("AddBtnTapped")
        //Create center point at screen to hitTest the center of the screen.
        let centerCGPoint = CGPoint(x: UIScreen.main.bounds.width*0.5, y: UIScreen.main.bounds.height*0.5)
        guard let hitTest = sceneView.hitTest(centerCGPoint, types: .existingPlaneUsingExtent).first else {return}
        
        //Create anchor at hitTest location
        let anchor = ARAnchor(transform: hitTest.worldTransform)
            
        //Add anchor to the scene
        sceneView.session.add(anchor: anchor)
        
        //Calling addModel to add the model onto a detected plane.
        addModel(hitTest: hitTest)
        print(modelNode!)
    }
    
    // MARK: - ARSCNViewDelegate
    /*
     // Override to create and configure nodes for anchors added to the view's session.
     func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
     let node = SCNNode()
     
     return node
     }
     */
    
    func session(_ session: ARSession, didFailWithError error: Error) {
        // Present an error message to the user
    }
    
    func sessionWasInterrupted(_ session: ARSession) {
        // Inform the user that the session has been interrupted, for example, by presenting an overlay
        
    }
    
    func sessionInterruptionEnded(_ session: ARSession) {
        // Reset tracking and/or remove existing anchors if consistent tracking is required
        
    }
    
    //Provide run-time tracking states to users.
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        //Show users the current states of ARCamera
        switch camera.trackingState {
        case .notAvailable:
            statusLabel.text = "Tracking not available"
            statusLabel.textColor = .red
        case .normal:
            statusLabel.text = "Tracking normal"
            statusLabel.textColor = .green
        case .limited(.excessiveMotion):
            statusLabel.text = "Tracking limited: excessive motion"
        case .limited(.insufficientFeatures):
            statusLabel.text = "Tracking limited: insufficient features"
        case .limited(.relocalizing):
            statusLabel.text = "Recovering from interruption"
        case .limited(.initializing):
            statusLabel.text = "Tracking limited: initializing"
            statusLabel.textColor = .yellow
        }
    }
/**
    // Mark: - renderer
    //There are automatically called when anchor and plane is automatically detecte by ARkit.
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }

        // Create a SceneKit plane to visualize the node using its position and extent.
        let plane = SCNPlane(width: CGFloat(0.1), height: CGFloat(0.1))
        let planeNode = SCNNode(geometry: plane)
        let planeMaterial = SCNMaterial()
        planeMaterial.diffuse.contents = UIColor.gray.withAlphaComponent(0.3)
        plane.materials = [planeMaterial]
        planeNode.position = SCNVector3Make(planeAnchor.center.x, 0, planeAnchor.center.z)
        
        // SCNPlanes are vertically oriented in their local coordinate space.
        // Rotate it to match the horizontal orientation of the ARPlaneAnchor.
        planeNode.transform = SCNMatrix4MakeRotation(-Float.pi / 2, 1, 0, 0)
        
        // ARKit owns the node corresponding to the anchor, so make the plane a child node.
        node.addChildNode(planeNode)
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
        guard let planeAnchor = anchor as?  ARPlaneAnchor,
            let planeNode = node.childNodes.first,
            let plane = planeNode.geometry as? SCNPlane
            else { return }
        let x = CGFloat(planeAnchor.center.x)
        let y = CGFloat(planeAnchor.center.y)
        let z = CGFloat(planeAnchor.center.z)
        planeNode.position = SCNVector3(x, y, z)
    }
*/
    
    //Tap detection to test View.
    @objc func tapped(gesture: UITapGestureRecognizer) {
        print("tapped")
    }
    
    //Add house model into the scene
    func addModel(hitTest: ARHitTestResult) {
        //Getting the house 3D model
        let scene = SCNScene(named: "art.scnassets/house.scn")!
        let houseNode = scene.rootNode.childNode(withName: "house", recursively: true)
        
        //Setting the model position within the scene.
        houseNode?.position = SCNVector3(hitTest.worldTransform.columns.3.x,hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
        print("X: ", hitTest.worldTransform.columns.3.x,"Y: ", hitTest.worldTransform.columns.3.y,"Z:", hitTest.worldTransform.columns.3.z)
        modelNode = houseNode
        sceneView.scene.rootNode.addChildNode(modelNode!)
    }
    
    @objc func rotate(_ gesture: UIPanGestureRecognizer) {
        guard let nodeToRotate = modelNode else {return}
        let translation = gesture.translation(in: gesture.view!)
        
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngleY += currentAngleY
        
        nodeToRotate.eulerAngles.y = newAngleY
        
        if(gesture.state == .ended) { currentAngleY = newAngleY }
        
        print(nodeToRotate.eulerAngles)
    }
}

