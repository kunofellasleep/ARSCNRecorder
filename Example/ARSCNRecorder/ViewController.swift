//
//  ViewController.swift
//  ARSCNRecorder
//
//  Created by kunofellasleep on 03/19/2019.
//  Copyright (c) 2019 kunofellasleep. All rights reserved.
//

import UIKit
import ARKit
import Photos
import ARSCNRecorder

class ViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!
    
    let recorder = ARSCNRecorder()
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        return configuration
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        sceneView.delegate = recorder
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        sceneView.session.pause()
        if recorder.getIsRecording() {
            recorder.cancelRecording()
            infoLabel.text = "Recording Canceled"
        }
    }
    
    @IBAction func onTappedRecordButton(_ sender: UIButton) {
        let isRecording = recorder.getIsRecording()
        if !isRecording {
            infoLabel.text = "Recording Started"
            sender.backgroundColor = .red
            recorder.startRecording(sceneView, ARSCNRecorderOptions())
        } else {
            infoLabel.text = "Recording Finished"
            sender.backgroundColor = .white
            recorder.finishRecording(isSaveLibrary: true) { url in
                print(url!)
            }
        }
    }
    
}
