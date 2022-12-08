//
//  CamaraVC.swift
//  ExamenSTLG
//
//  Created by Sergio Torres Landa González on 07/12/22.
//


import UIKit
import AVFoundation

@available(iOS 13.0, *)
class CameraVC: UIViewController {

    @IBOutlet weak var Progress: UIActivityIndicatorView!
    @IBOutlet weak var CameraBtn: UIButton!
    
    var previewLayer : CALayer!
    var ds = DispatchGroup()
    let defaults = UserDefaults.standard
    //var captureSession : AVCaptureSession!
    var captureSession = AVCaptureSession()
    var captureDevice : AVCaptureDevice!
    var backCamera : AVCaptureDevice!
    var frontCamera : AVCaptureDevice!
    var backInput : AVCaptureInput!
    var frontInput : AVCaptureInput!
    //var previewLayer : AVCaptureVideoPreviewLayer!
    var videoOutput : AVCaptureVideoDataOutput!
    var takePicture = false
    var cameraView : UIView!
    var image: UIImage!
    var imgData:Data?
    
    @IBAction func CameraClick(_ sender: Any) {
        takePicture = true
        CameraBtn.isHidden=true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Progress.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        CameraBtn.isHidden=false
        setupAndStartCaptureSession()
        ds.enter()
        ds.notify(queue: .main){
            self.Progress.isHidden=true
            self.Progress.stopAnimating()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopSession()
    }
    

    func prepareCamera(){
        captureSession.sessionPreset = AVCaptureSession.Preset.photo
    }
    // MARK: CAPTURE SESSION
    func setupAndStartCaptureSession(){
        print("setupAndStart")
            DispatchQueue.global(qos: .userInitiated).async{
                //init session
                self.captureSession = AVCaptureSession()
                //start configuration
                self.captureSession.beginConfiguration()
                //do some configuration?
                if self.captureSession.canSetSessionPreset(.photo) {
                    self.captureSession.sessionPreset = .photo
                    print(".photo")
                        }
                self.captureSession.automaticallyConfiguresCaptureDeviceForWideColor = true
                self.setupInputs()
                
                DispatchQueue.main.async {
                    self.setupPreviewLayer()
                    print("main")
                }
                
                self.setupOutput()
          
                self.captureSession.commitConfiguration()
                self.captureSession.startRunning()
            }
        }
    
    func setupInputs(){
            //get back camera
            if let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                backCamera = device
                print(".getback")
            } else {
                let alert = UIAlertController(title: "¡Ups!", message: "Tu dispositivo no cuenta con camara para tomar la foto.", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "¡Entendido!", style: .default, handler: { (action: UIAlertAction!) in
                    
                }))
                self.present(alert, animated: true, completion: nil)
                //fatalError("no back camera")
                _ = self.navigationController?.popViewController(animated: true)

                return
            }
            //now we need to create an input objects from our devices
            guard let bInput = try? AVCaptureDeviceInput(device: backCamera) else {
                requestPermissionCamera()
                return
            }
            backInput = bInput
            print(".backimput")
            if !captureSession.canAddInput(backInput) {
                for inputs in captureSession.inputs{
                    captureSession.removeInput(inputs)
                }
                if !captureSession.canAddInput(backInput){
                    requestPermissionCamera()
                }else{
                    captureSession.addInput(backInput)
                }
            }else{
                captureSession.addInput(backInput)
            }
    }
    
    func requestPermissionCamera(){
        AVCaptureDevice.requestAccess(for: AVMediaType.video) { response in
               if response {
                self.captureSession.addInput(self.backInput)
               } else {
                let alert = UIAlertController(title: "¡Ups!", message: "Necesitamos los permisos de tu cámara para tomar tus fotos, en tu iPhone ve a  Configuración->Pivacidad->Cámara y asegurate que la app de Clupp tenga el permiso habilitado", preferredStyle: UIAlertController.Style.alert)
                
                alert.addAction(UIAlertAction(title: "Entendido", style: .cancel, handler: { (action: UIAlertAction!) in
                    _ = self.navigationController?.popViewController(animated: true)
                }))
                self.present(alert, animated: true, completion: nil)
               }
           }
    }
    
    func setupPreviewLayer(){
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        cameraView = UIView()
        self.view.layer.addSublayer(previewLayer)
        previewLayer.addSublayer(addOverlay0()!.layer)
        previewLayer.frame = self.view.layer.frame
        print("setupPreview")
    }
    
    func addOverlay0() -> UIView? {
        //self.addOverlay(cameraView)
        return cameraView
    }
    
    func setupOutput(){
            videoOutput = AVCaptureVideoDataOutput()
            let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
            videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
            
            if captureSession.canAddOutput(videoOutput) {
                captureSession.addOutput(videoOutput)
            } else {
                fatalError("could not add video output")
            }
        }
    
    func stopSession(){
        self.captureSession.stopRunning()
        if let inputs = captureSession.inputs as? [AVCaptureDeviceInput] {
            for input in inputs {
                self.captureSession.removeInput(input)
            }
        }
    }

}

@available(iOS 13.0, *)
extension CameraVC: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        
        if !takePicture {
            return
        }
        
        guard let cvBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {
            return
        }
        
        let ciImage = CIImage(cvImageBuffer: cvBuffer)
        //EL SIGUIENTE BLOQUE ES PARA STORAGE
        let uiImage = UIImage(ciImage: ciImage)
        //Reducir tamaño
        let a = uiImage.resizeWithPercent(percentage: 0.3)
        let cData = a?.jpegData(compressionQuality: 0.4)
       
        let x = UIImage(data: cData!)
    
        let data = x!.pngData()
        imgData = data //esto es lo q se sube a Storage
        
        //subirFotoStorage()
        DispatchQueue.main.async {
            self.takePicture = false
            print("takepicFalse")
        
            self.defaults.set(data, forKey: "foto")
            _ = self.navigationController?.popViewController(animated: true)
        }
        self.previewLayer.removeFromSuperlayer()
    }
}

extension UIImage {
    func resizeWithPercent(percentage: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: size.width * percentage, height: size.height * percentage)))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
    
    func resizeWithWidth(width: CGFloat) -> UIImage? {
        let imageView = UIImageView(frame: CGRect(origin: .zero, size: CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))))
        imageView.contentMode = .scaleAspectFit
        imageView.image = self
        UIGraphicsBeginImageContextWithOptions(imageView.bounds.size, false, scale)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.render(in: context)
        guard let result = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        UIGraphicsEndImageContext()
        return result
    }
}
