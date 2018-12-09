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
        
        // Create a new scene
        let scene = SCNScene()
        
        // Set the scene to the view
        sceneView.scene = scene
        
        addPlane()
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
        planeNode?.scale = .init(0.05, 0.05, 0.05) // some dot shorts...
        let bannerNode = planeNode?.childNode(withName: "banner", recursively: false)
        
        let bannerMaterial = bannerNode?.geometry?.materials.first(where: {$0.name == "logo"})
        bannerMaterial?.diffuse.contents = UIImage(named: "plane-banner-blue-logo")
        
        self.sceneView.scene.rootNode.addChildNode(planeNode!)
        
    }
}
