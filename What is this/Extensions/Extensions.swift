//
//  Extensions.swift
//  What is this
//
//  Created by Lucas Moraes on 06/11/2017.
//  Copyright © 2017 Lucas Moraes. All rights reserved.
//

import UIKit
import AVFoundation
import CoreML
import Vision

extension CameraViewController: AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        if error != nil {
            debugPrint(error!)
            return
        } else {
            photoData = photo.fileDataRepresentation()
            
            do {
                let model = try VNCoreMLModel(for: SqueezeNet().model)
                let request = VNCoreMLRequest(model: model, completionHandler: resultMethod)
                let handler = VNImageRequestHandler(data: photoData!)
                try handler.perform([request])
            } catch {
                debugPrint(error)
            }
            
            let image = UIImage(data: photoData!)
            self.capImageView.image = image
        }
    }
    // Handling the completionHandler
    func resultMethod(request: VNRequest, error: Error?){
        guard let results = request.results as? [VNClassificationObservation] else {
            return
        }
        
        for classification in results {
            if classification.confidence < 0.5 {
                let unkonwMessage = "I don't know what this is. Please try again !"
                self.titleLabel.text = unkonwMessage
                synthesizerSpeech(from: unkonwMessage)
                self.confidentialLabel.text = ""
                break
            } else {
                
                
                let identification = classification.identifier
                let confidence = Int(classification.confidence * 100)
                let sentence = "Well this is an \(identification) I'm \(confidence) percent sure"
                
                self.titleLabel.text = "Well this is \(identification)"
                self.confidentialLabel.text = "Confidence: \(confidence)%"
                synthesizerSpeech(from: sentence)
                break
            }
        }
    }
}

extension CameraViewController: AVSpeechSynthesizerDelegate {
    
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        
    }
}








