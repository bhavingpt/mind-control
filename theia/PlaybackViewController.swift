//
//  ViewController.swift
//  theia
//
//  Created by Bhavin Gupta on 6/26/17.
//  Copyright © 2017 bhavingpt. All rights reserved.
//

import Cocoa
import Foundation
import AVFoundation

class PlaybackViewController: NSViewController {
    
    // MARK: AVFoundation variables
    
    let captureSession = AVCaptureSession()
    var captureDevice: AVCaptureDevice?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var previewPanel: NSView!
    
    // MARK: CGEvents
    // TODO ghetto af, make customizable

    let pressJ: CGEvent = CGEvent(keyboardEventSource: nil, virtualKey: 38, keyDown: true)!
    let letgoJ: CGEvent = CGEvent(keyboardEventSource: nil, virtualKey: 38, keyDown: false)!

    override func viewDidLoad() {
        super.viewDidLoad()

        captureSession.sessionPreset = AVCaptureSessionPresetLow
        let devices = AVCaptureDevice.devices()
        for device in devices! {
            if ((device as AnyObject).hasMediaType(AVMediaTypeVideo)) {
                captureDevice = device as? AVCaptureDevice
            }
        }
                
        do {
            let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
            captureSession.addInput(deviceInput)
            
            previewPanel = self.view.subviews.first // get out the custom view
            previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer!.frame = self.view.bounds
            
            previewLayer!.videoGravity = AVLayerVideoGravityResizeAspectFill
            previewPanel.layer?.addSublayer(previewLayer!)
            
        } catch let error as NSError {
            Swift.print("Error: no valid camera input in \(error.domain)")
        }
        
    }
    
    public func startCamera() {
        captureSession.startRunning()
        pressJ.post(tap: CGEventTapLocation.cghidEventTap) // TODO so this is just creating one tap
    }
    
    public func stopCamera() {
        if captureSession.isRunning {
            captureSession.stopRunning()
            letgoJ.post(tap: CGEventTapLocation.cghidEventTap)
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

