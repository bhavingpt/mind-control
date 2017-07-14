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

class PlaybackViewController: NSViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    @IBOutlet weak var imageView: NSImageView!
    
    var session: AVCaptureSession!
    var device: AVCaptureDevice!
    var output: AVCaptureVideoDataOutput!
    var cv2: OpenCVWrapper = OpenCVWrapper()
    var hid: MyHIDDevice = MyHIDDevice()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.imageView.setContentCompressionResistancePriority(250, for: NSLayoutConstraintOrientation.horizontal)
        self.imageView.setContentCompressionResistancePriority(250, for: NSLayoutConstraintOrientation.vertical)

        self.session = AVCaptureSession()
        self.session.sessionPreset = AVCaptureSessionPresetLow
        for device in AVCaptureDevice.devices() {
            self.device = device as! AVCaptureDevice
        }
        if (self.device == nil) {
            print ("no webcam found")
            return
        }
        
        do {
            let input = try AVCaptureDeviceInput(device: self.device)
            self.session.addInput(input)
        } catch {
            print ("no input found")
            return
        }
        
        self.output = AVCaptureVideoDataOutput()
        self.output.videoSettings = [ kCVPixelBufferPixelFormatTypeKey as String: Int(kCVPixelFormatType_32BGRA)]
        let queue: DispatchQueue = DispatchQueue(label: "videocapturequeue", attributes: [])
        self.output.setSampleBufferDelegate(self, queue: queue)
        self.output.alwaysDiscardsLateVideoFrames = true
        
        if self.session.canAddOutput(self.output) {
            self.session.addOutput(self.output)
        } else {
            print ("couldn't add output")
            return
        }
        
    }
    
    public func startCamera() {
        self.session.startRunning()
        hid.postKeyCodeEvent(0x0e, true, false);
    }
    
    public func stopCamera() {
        if (self.session.isRunning) {
            self.session.stopRunning()
            hid.postKeyCodeEvent(0x0e, false, false);
        }
    }
    
    private func detectChanges() {
        if (cv2.pushKey != 0) {
            //print ("posting");
            //hid.postKeyCodeEvent(0x0e, true, true);
        } else if (cv2.raiseKey != 0) {
            //print ("releasing");
            //hid.postKeyCodeEvent(0x0e, false, true);
        }
    }
    
    func captureOutput(_ captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, from connection: AVCaptureConnection!) {
        // Convert a captured image buffer to NSImage.
        guard let buffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            print("couldn't get pixel buffer")
            return
        }
        CVPixelBufferLockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)
        let imageRep = NSCIImageRep(ciImage: CIImage(cvImageBuffer: buffer))
        let capturedImage = NSImage(size: imageRep.size)
        capturedImage.addRepresentation(imageRep)
        CVPixelBufferUnlockBaseAddress(buffer, CVPixelBufferLockFlags.readOnly)
        
        // This is a filtering sample.
        let resultImage = cv2.detect(capturedImage)
        
        detectChanges()
        
        // Show the result.
        DispatchQueue.main.async(execute: {
            self.imageView.image = resultImage;
        })
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

