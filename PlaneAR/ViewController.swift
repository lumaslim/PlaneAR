//
//  ViewController.swift
//  PlaneAR
//
//  Created by SLim on 8/12/18.
//  Copyright © 2018 SLim. All rights reserved.
//

import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    @IBOutlet var sceneView: ARSCNView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the view's delegate
        sceneView.delegate = self
        
        // Show statistics such as fps and timing information
        sceneView.showsStatistics = true
        // Debug feature points
        sceneView.debugOptions = [ .showFeaturePoints,
                                   .showCameras,
                                   .showCreases,
                                   .showSkeletons,
                                   .showConstraints,
                                   .showLightInfluences ]
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addPlane()
        
        
        // Add gesture recognisers
        let doubleTapGesture: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(doubleTapped))
        doubleTapGesture.numberOfTapsRequired = 2
        
        sceneView.addGestureRecognizer(doubleTapGesture)
        print("ViewDidLoad:: Finished")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
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
}

extension ViewController {
    private func addPlane() {
        let planeBannerScene = SCNScene(named: "art.scnassets/plane_banner.scn")! // Where are the string dir autocompletion... Xcode y u do dis!?¿¿¿🦞
        
        let planeNode = planeBannerScene.rootNode.childNode(withName: "planeBanner", recursively: false)
        planeNode?.name = "plane"
        planeNode?.scale = .init(0.05, 0.05, 0.05) // some dot shorts...

        let bannerNode = planeNode?.childNode(withName: "banner", recursively: false)
        
        let bannerMaterial = bannerNode?.geometry?.materials.first(where: {$0.name == "logo"})
        bannerMaterial?.diffuse.contents = UIImage(named: "art.scnassets/plane-banner-blue-logo")
        sceneView.showsStatistics = true
        sceneView.scene.rootNode.addChildNode(planeNode!)
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touchPosition = touches.first?.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(touchPosition!, types: .featurePoint)
        
        if !hitTestResult.isEmpty {
            guard let hitResult = hitTestResult.first else { return }
            print("touchesMoved:: touch", hitResult.worldTransform.columns.3)
            
        }
    }
}

extension ViewController {
    
    @objc func doubleTapped(doubleTapGesture: UIGestureRecognizer) {
        print("doubleTapped::")
        // 2D screen coordinate
        let touch2DPosition = doubleTapGesture.location(in: sceneView)
        
        let hitTestResult = sceneView.hitTest(touch2DPosition, types: .featurePoint)
        
        guard let hitResult = hitTestResult.first else { return }
        
        print("doubleTapped:: hitResult", hitResult)
        // Transform matrix indicates intersection point between detected surface and hit ray.
        // Should probably learn a dedicated linear algebra course.. LAFF
        let touchPosHitWorldCoords = hitResult.worldTransform.columns.3
        let touchPositionPoint = SCNVector3(touchPosHitWorldCoords.x, touchPosHitWorldCoords.y, touchPosHitWorldCoords.z)
        
        let finishFlagsNode = createFinishFlagsDestinationNode(flagsPlane: createFinishFlags2DSurface(), nodePosition: touchPositionPoint)
        
        sceneView.scene.rootNode.addChildNode(finishFlagsNode)
        
        // rip reference to aeroplane plane
        guard let plane = sceneView.scene.rootNode.childNode(withName: "plane", recursively: true) else { return }
        
        movePlane(plane, to: touchPositionPoint, finish: finishFlagsNode)
        print(finishFlagsNode)
    }
    static private func createFinishFlagsDestination() {
        
    }
    private func createFinishFlags2DSurface() -> SCNPlane {
        let flatSurfacePlaneGeometry = SCNPlane(width: 0.2, height: 0.2)
        
        let flagMaterial = SCNMaterial()
        flagMaterial.diffuse.contents = UIImage(named: "art.scnassets/finish-flags.png")
        
        flatSurfacePlaneGeometry.materials = [ flagMaterial ]
        
        return flatSurfacePlaneGeometry
    }
    private func createFinishFlagsDestinationNode(flagsPlane: SCNPlane, nodePosition: SCNVector3) -> SCNNode {
        let finishFlags2DNode = SCNNode(geometry: flagsPlane)
        finishFlags2DNode.name = "finish"
        
        finishFlags2DNode.position = nodePosition
        
        return finishFlags2DNode
    }
    private func movePlane(_ plane: SCNNode, to destinationPoint: SCNVector3, finish: SCNNode) {
        let flyAction = SCNAction.move(to: destinationPoint, duration: 5)
        
        plane.runAction(flyAction)
    }
    
}


extension ViewController: SCNPhysicsContactDelegate {
    
}
