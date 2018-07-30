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
import Foundation


class ViewController: UIViewController, ARSCNViewDelegate {
    //Mark: Outlets
    @IBOutlet weak var ARSCNView: ARSCNView!
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBAction func nextPageButtonPressed(_sender: Any){
        self.performSegue(withIdentifier: "SecondViewSegue", sender: self)
    }
    
    struct AnimationInfo{
        var startTime: TimeInterval
        var duration: TimeInterval
        var initialPosition: float3
        var finalPosition: float3
        var initialOrientation: simd_quatf
        var finalOrientation: simd_quatf
    }

    var textValue = ""
    var state = false
    var featurePts = ARSCNDebugOptions.showFeaturePoints
    
    //Mark: Variables
    var modelNode: SCNNode?
    var currentAngleY: Float = 0.0
    var secondResultLabelText : String!
    private var houseNode : SCNNode?
    private var imageNode: SCNNode?
    private var animationInfo: ViewController.AnimationInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //Set the view's delegate
        sceneView.delegate = self
        self.statusLabel.isHidden = state
        self.sceneView.debugOptions = featurePts
        print(textValue)
        
        //Display arkit stat
        sceneView.showsStatistics = true
        
        //Create a new scene
        let scene = SCNScene()
        
        sceneView.scene = scene
        
        print(secondResultLabelText) 
        //statusLabel UI configuration
        statusLabel.layer.masksToBounds = true
        statusLabel.layer.cornerRadius = 8
        statusLabel.adjustsFontForContentSizeCategory = true
        statusLabel.adjustsFontSizeToFitWidth = true
        statusLabel.isHidden = true //Hidden until switched on in Setting
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        
        
        configuration.planeDetection = .horizontal
        
        // Allow image recognition 
        guard let referenceImages = ARReferenceImage.referenceImages(inGroupNamed: "AR Resources", bundle: nil)
        else {
            fatalError("Missing expected asset catalog resources")
        }
        
        configuration.detectionImages = referenceImages
        // Run the view's session
        sceneView.session.run(configuration)
        
        let rotateGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(rotate))
        sceneView.addGestureRecognizer(rotateGestureRecognizer)
        let scalingGestureRecognizer = UIPinchGestureRecognizer(target: self, action: #selector(scale))
        sceneView.addGestureRecognizer(scalingGestureRecognizer)
        
        
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

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "SettingViewSegue" {
//            let secondView = segue.destination as? SettingViewController
//        }
//    }
    
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
    
    @IBAction func ResetButton(_ sender: UIButton) {
        print("Reset session with new session created")
        //Remove all of the Node (children nodes) generated within the scene.
        self.sceneView.scene.rootNode.enumerateChildNodes { (node, stop) in
            node.removeFromParentNode()
        }
        
        //Re-initialize a new SCNScene session while clearing the previous session.
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = [.horizontal]
        sceneView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
    }
    
    //MARK: Setting popover
    @IBOutlet var subView: UIView!
    
    @IBAction func SettingButton(_ sender: UIButton) {
        print("Setting Button Pressed")
        self.view.addSubview(subView)
        subView.center = self.view.center
    }
    
    @IBAction func subViewDone(_ sender: Any) {
        self.subView.removeFromSuperview()
    }
    
    @IBOutlet var modelView: UITableView!
    
    @IBAction func ModelsButton(_sender: UIButton){
        print("Models Button Pressed")
        self.view.addSubview(modelView)
        modelView.center = self.view.center
    }
    
    @IBAction func modelViewFinish(_sender: Any){
        self.subView.removeFromSuperview()
    }

    /*
    @IBAction func trackingStateSwitch(_ sender: UISwitch) {
        if (sender.isOn == false) {
            statusLabel.isHidden = true;
        } else {
            statusLabel.isHidden = false;
        }
    }
 
 
    
    
    
    @IBAction func featurePointSwitch(_ sender: UISwitch) {
        if (sender.isOn == true) {
            //Show yellow feature points
            sceneView.debugOptions = ARSCNDebugOptions.showFeaturePoints
        } else {
             sceneView.debugOptions = []
        }
    }
 
     */
    
    

    
    
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
    
    //Provide run-time tracking states which is displayed by statusLabel
    func session(_ session: ARSession, cameraDidChangeTrackingState camera: ARCamera) {
        //Show users the current states of ARCamera
        switch camera.trackingState {
        case .notAvailable:
            statusLabel.text = "Tracking not available"
        case .normal:
            statusLabel.text = "Tracking normal"
        case .limited(.excessiveMotion):
            statusLabel.text = "Tracking limited: excessive motion"
        case .limited(.insufficientFeatures):
            statusLabel.text = "Tracking limited: insufficient features"
        case .limited(.relocalizing):
            statusLabel.text = "Recovering from interruption"
        case .limited(.initializing):
            statusLabel.text = "Tracking limited: initializing"
        }
    }
    // Mark: - renderer
    
/**
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
    
    //Set image//
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor){
        guard let imageAnchor = anchor as? ARImageAnchor else {
        return
        }
        //Get 3D model//
        let scene = SCNScene(named: "art.scnassets/\(textValue).scn")!
        let houseNode = scene.rootNode.childNode(withName: "house", recursively: true)!
    
        ///Calculate bounding box//
        let (min, max) = houseNode.boundingBox
        let size = SCNVector3(max.x - min.x, max.y - min.y, max.z - min.z)
    
    
        //Ratio images//
        let widthRatio = Float(imageAnchor.referenceImage.physicalSize.width) / size.x
        let heightRatio = Float(imageAnchor.referenceImage.physicalSize.height) / size.z
    
    
        ///Transform the model//
        let ratioBest = [widthRatio, heightRatio].min()
        houseNode.transform = SCNMatrix4(imageAnchor.transform)
    
        let imageAction = SCNAction.scale(to: CGFloat(ratioBest!), duration: 0.5)
        imageAction.timingMode = .easeOut
    
        houseNode.scale = SCNVector3(0,0,0)
        //Add to root//
        sceneView.scene.rootNode.addChildNode(houseNode)
        houseNode.runAction(imageAction)
    
        self.houseNode = houseNode
        self.imageNode = node
    }
    
    func renderer(_ renderer: SCNSceneRenderer, updateAtTime time: TimeInterval){
        guard let imageNode = imageNode,
            let houseNode = houseNode else{
                return
        }
        
        
        ///Set animation position & orientation//
        guard let animationInfo = animationInfo else {
            refreshAnimationVariables( startTime: time,
                                       initialPosition: houseNode.simdWorldPosition,
                                       finalPosition: imageNode.simdWorldPosition,
                                       initialOrientation: houseNode.simdWorldOrientation,
                                       finalOrientation: imageNode.simdWorldOrientation
                                       )
            return
        }
        
        if !simd_equal(animationInfo.finalPosition, animationInfo.finalPosition) || animationInfo.initialOrientation != animationInfo.finalOrientation {
            refreshAnimationVariables(startTime: time, initialPosition: houseNode.simdWorldPosition, finalPosition: imageNode.simdWorldPosition, initialOrientation: houseNode.simdWorldOrientation, finalOrientation: imageNode.simdWorldOrientation)
            
            //Transition time//
            let timePassed = time - animationInfo.duration
            var t = min(Float(timePassed / animationInfo.duration),1)
            t = sin (t * .pi * 0.5)
            
            //Reposition new model//
            let new_t = simd_make_float3(t,t,t)
            
            houseNode.simdWorldPosition = simd_mix(animationInfo.initialPosition, animationInfo.finalPosition, new_t)
            houseNode.simdWorldOrientation = simd_slerp(animationInfo.initialOrientation, animationInfo.finalOrientation, t)
            
        }
        
    }
    
    func refreshAnimationVariables(startTime: TimeInterval, initialPosition: float3, finalPosition: float3, initialOrientation: simd_quatf, finalOrientation: simd_quatf){
        let distance = simd_distance(initialPosition, finalPosition)
        
        //Set movement speed//
        let speed = Float(0.2)
        
        let animationDuration = Double(min(max(0.1, distance / speed), 2))
        
        animationInfo = ViewController.AnimationInfo (
            startTime: startTime,
            duration: animationDuration,
            initialPosition: initialPosition,
            finalPosition: finalPosition,
            initialOrientation: initialOrientation,
            finalOrientation: finalOrientation
         )
        
    }
    
    //Add house model into the scene
    func addModel(hitTest: ARHitTestResult) {
        
        //Get 3D model//
        let scene = SCNScene(named: "art.scnassets/house.scn")!
        let houseNode = scene.rootNode.childNode(withName: "house", recursively: true)!
        
        //Set the model position within the scene.
        houseNode.position = SCNVector3(hitTest.worldTransform.columns.3.x,hitTest.worldTransform.columns.3.y, hitTest.worldTransform.columns.3.z)
        print("X: ", hitTest.worldTransform.columns.3.x,"Y: ", hitTest.worldTransform.columns.3.y,"Z:", hitTest.worldTransform.columns.3.z)
        modelNode = houseNode
        sceneView.scene.rootNode.addChildNode(modelNode!)
        print(modelNode?.name! as Any)
        
    }
    
    //MARK: Anchored object manipulation
    //Rotation of model node.
    @objc func rotate(_ gesture: UIPanGestureRecognizer) {
        guard let nodeToRotate = modelNode else {return}
        let translation = gesture.translation(in: gesture.view!)
        
        var newAngleY = (Float)(translation.x)*(Float)(Double.pi)/180.0
        newAngleY += currentAngleY
        
        nodeToRotate.eulerAngles.y = newAngleY
        
        if(gesture.state == .ended) { currentAngleY = newAngleY }
        
        print(nodeToRotate.eulerAngles)
    }
    
    //Scaling of the model node.
    @objc func scale(_ gesture: UIPinchGestureRecognizer) {
        guard let nodeToScale = modelNode else {return}
        
        if gesture.state == .changed {
            let pinchToScaleX: CGFloat = gesture.scale * CGFloat(nodeToScale.scale.x)
            let pinchToScaleY: CGFloat = gesture.scale * CGFloat(nodeToScale.scale.y)
            let pinchToScaleZ: CGFloat = gesture.scale * CGFloat(nodeToScale.scale.z)
            
            //After getting pinch intensity in CGFloat, pass them to scale.
            nodeToScale.scale = SCNVector3Make(Float(pinchToScaleX),Float(pinchToScaleY),Float(pinchToScaleZ))
            
            print(nodeToScale.scale)
            print("Velocity: ",gesture.velocity)

            gesture.scale = 1 //Reset the new scale to 1 -> give more accurate scaling.
        }
        if gesture.state == .ended {print("Pinch gestured completed.", "Pinch scale set to: ", gesture.scale)}
    }
    
}









