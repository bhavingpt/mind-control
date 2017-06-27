//
//  ViewController.swift
//  theia
//
//  Created by Bhavin Gupta on 6/26/17.
//  Copyright © 2017 bhavingpt. All rights reserved.
//

import Cocoa
import AVFoundation

class PlaybackViewController: NSViewController {
    
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var previewLayerOne: AVCaptureVideoPreviewLayer?
    var previewPanelOne: NSView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                captureDevice = device as? AVCaptureDevice
            }
        }
        
        Swift.print("Starting...")
        
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(deviceInput)
            
            previewPanelOne = self.view.subviews.first // get out the custom view
            previewLayerOne = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayerOne!.frame = (self.view.subviews.first?.bounds)!
            
            previewLayerOne!.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewPanelOne.layer?.addSublayer(previewLayerOne!)
            captureSession.startRunning()
        
        } catch let error as NSError {
            Swift.print("Error: no valid camera input in \(error.domain)")
        }
        
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

