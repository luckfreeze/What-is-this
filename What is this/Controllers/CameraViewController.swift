//
//  ViewController.swift
//  What is this
//
//  Created by Lucas Moraes on 06/11/2017.
//  Copyright © 2017 Lucas Moraes. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision



class CameraViewController: UIViewController {

    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var confidentialLabel: UILabel!
    
    @IBOutlet weak var capImageView: UIImageView!
 
   
    
    let camera = AVCaptureDevice.default(for: AVMediaType.video)
    
    var session: AVCaptureSession!
    var cameraOutput: AVCapturePhotoOutput!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    var photoData :Data?
    
    var speechSynthesizer = AVSpeechSynthesizer()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(takePhoto))
        tap.numberOfTapsRequired = 1
        
        session = AVCaptureSession()
        session.sessionPreset = AVCaptureSession.Preset.high // MARK: Remind later
        
        do {
            let input = try AVCaptureDeviceInput(device: camera!)
            if session.canAddInput(input) == true {
                session.addInput(input)
            }
            
            cameraOutput = AVCapturePhotoOutput()
            if session.canAddOutput(cameraOutput) == true {
                session.addOutput(cameraOutput!)
                previewLayer = AVCaptureVideoPreviewLayer(session: session!)
                previewLayer.videoGravity = AVLayerVideoGravity.resizeAspect
                previewLayer.connection?.videoOrientation = AVCaptureVideoOrientation.portrait
                
                cameraView.layer.addSublayer(previewLayer)
                cameraView.addGestureRecognizer(tap)
                session.startRunning()
            }
        } catch {
            debugPrint(error)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        previewLayer.frame = cameraView.bounds
        speechSynthesizer.delegate = self
    }
    
    override func viewDidLoad() { super.viewDidLoad() }

    @objc func takePhoto() {
        let settings = AVCapturePhotoSettings()
        let previewType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        
        settings.previewPhotoFormat = previewFormat
        cameraOutput.capturePhoto(with: settings, delegate: self)
    }
    
    func synthesizerSpeech(from string:String) {
        let speechUtterance = AVSpeechUtterance(string: string)
        speechSynthesizer.speak(speechUtterance)
    }
    
}





































