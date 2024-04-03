//
//  GameViewController.swift
//  GravityNode
//
//  Created by Jeff Handy on 3/31/24.
//

import SceneKit
import QuartzCore
import Foundation

let sunGravity: UInt32 = 0x1 << 0
let earthGravity: UInt32 = 0x1 << 1
let marsGravity: UInt32 = 0x1 << 2
let DEBUG = false


class GameViewController: NSViewController {
    
    func makeNode(radius: CGFloat, mass: CGFloat, category: UInt32, type: SCNPhysicsBodyType, image: String? = nil) -> SCNNode {
        
        let material = SCNMaterial()
        
        if let image = image {
            material.diffuse.contents = NSImage(named: image)
        } else {
            material.diffuse.contents = NSColor.white
        }
        
        // Apply the material to the geometry
        let sphere = SCNSphere(radius: radius)
        sphere.materials = [material]
        
        let node = SCNNode(geometry: sphere)
        node.position = SCNVector3(0, 0, 0)
        
        node.physicsBody = SCNPhysicsBody(type: type, shape: SCNPhysicsShape(geometry: node.geometry!, options: nil))
        node.physicsBody?.damping = 0
        
        return node
        
    }
    
    func makeField(node: SCNNode, strength: CGFloat)  {
        let gField = SCNPhysicsField.radialGravity()
        gField.strength = strength
        gField.falloffExponent = 10
        node.physicsField = gField
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // create a new scene
        let scene = SCNScene(named: "art.scnassets/scene.scn")!
        scene.physicsWorld.gravity = SCNVector3(0, 0, 0)
        
        // create and add a camera to the scene
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        scene.rootNode.addChildNode(cameraNode)
        
        // place the camera
        cameraNode.position = SCNVector3(x: 0, y: 0, z: 15)
        
        // create and add a light to the scene
        let lightNode = SCNNode()
        lightNode.light = SCNLight()
        lightNode.light!.type = .omni
        lightNode.position = SCNVector3(x: 0, y: 10, z: 10)
        scene.rootNode.addChildNode(lightNode)
        
        // create and add an ambient light to the scene
        let ambientLightNode = SCNNode()
        ambientLightNode.light = SCNLight()
        ambientLightNode.light!.type = .ambient
        ambientLightNode.light!.color = NSColor.darkGray
        scene.rootNode.addChildNode(ambientLightNode)
        
        /*         add nodes here       */
        
        //make sun
        let sun = makeNode(radius: 2, mass: 10000, category: sunGravity, type: .static, image: "sun")
        sun.position = SCNVector3(0, 0, 0)
        scene.rootNode.addChildNode(sun)
        
        //make earth
        let earth = makeNode(radius: 0.4, mass: 1, category: earthGravity, type: .dynamic, image: "earth")
        earth.position = SCNVector3(6, 0, 0)
        scene.rootNode.addChildNode(earth)
        
        // make mars
        let mars = makeNode(radius: 0.3, mass: 1, category: marsGravity, type: .dynamic, image: "mars")
        mars.position = SCNVector3(8, 0, 0)
        scene.rootNode.addChildNode(mars)
        
        //create a field
        makeField(node: sun, strength: 1.2)
        
        // Apply an impulse force to the node
        let impulseVector = SCNVector3(-0.7, 0, 0.7) // Impulse force along the y-axis
        earth.physicsBody?.applyForce(impulseVector, asImpulse: true)
        
        let impulseVector2 = SCNVector3(-0.5, 0, 0.5) // Impulse force along the y-axis
        mars.physicsBody?.applyForce(impulseVector2, asImpulse: true)
        
        
        // retrieve the SCNView
        let scnView = self.view as! SCNView
        if DEBUG { scnView.debugOptions = [.showPhysicsShapes] }
        
        // set the scene to the view
        scnView.scene = scene
        
        // allows the user to manipulate the camera
        scnView.allowsCameraControl = true
        
        // show statistics such as fps and timing information
        scnView.showsStatistics = true
        
        // configure the view
        scnView.backgroundColor = NSColor.black
        
    }
    
}

