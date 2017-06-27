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
        self.tapButton(button: 38)
    }
    
    public func stopCamera() {
        if captureSession.isRunning {
            captureSession.stopRunning()
            // TODO stop all keypresses by force
        }
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func tapButton(button: CGKeyCode) {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: true)
        event?.post(tap: CGEventTapLocation.cgSessionEventTap)
    }
    
    func untapButton(button: CGKeyCode) {
        let event = CGEvent(keyboardEventSource: nil, virtualKey: button, keyDown: false)
        event?.post(tap: CGEventTapLocation.cgSessionEventTap)
    }


}

