//
//  AnimVC.swift
//  KeyFrameDemo
//
//  Created by Kaira on 10/01/19.
//  Copyright © 2019 Kaira. All rights reserved.
//

import UIKit
import AVFoundation
import CoreAudioKit

public let kLidOpeningKeyPath = "transform.rotation.z"
public let KeyFrameclose = "close"


public let kAnimationNameKey = "animation_name"
public let kScrapDriveUpAnimationName = "scrap_drive_up_animation"
public let kScrapDriveDownAnimationName = "scrap_drive_down_animation"
public let kBucketDriveUpAnimationName = "bucket_drive_up_animation"
public let kBucketDriveDownAnimationName = "bucket_drive_down_animation"


let kScrapDriveUpAnimationHeight:CGFloat = 200
let kScrapYOffsetFromBase = 7

func DegreesToRadians(degree: CGFloat) -> CGFloat
{
    return degree * CGFloat.pi / 180
}

@available(iOS 10.0, *)
class AnimVC: UIViewController {
    
    @IBOutlet weak var IBlblDescription: UILabel!
    
    @IBOutlet weak var IBimgBell: UIImageView!
    @IBOutlet weak var IBlblTitle: UILabel!
    
    @IBOutlet weak var bucketLid: UIImageView!
    @IBOutlet weak var mic: UIImageView!
    @IBOutlet weak var bucketbody: UIImageView!
    let bucketLidImage  = #imageLiteral(resourceName: "BucketLid")
    let bucketBodyImage = #imageLiteral(resourceName: "bucket_body_style2")
    var animationDuration = 0.1
    var animationTimingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseInEaseOut)
    var degreesVariance = -60
    var interspace = 0
    var isOPen = false
    var isPlaying = false
    var bucketLidAnchorPoint = CGPoint(x: CGFloat(0.03), y: CGFloat(0.5))
    @IBOutlet weak var IBbtn: UIButton!
    @IBOutlet weak var IBViewBox: UIView!
    var i = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setBucketLayer()
        self.IBimgBell.setAnchorPoint(CGPoint(x: CGFloat(0.5), y: CGFloat(0)))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnAnimTouched(_ sender: Any) {
//        self.playSound()
//        if #available(iOS 10.0, *) {
//            Timer.scheduledTimer(withTimeInterval: 0.4, repeats: true) { (timer) in
//                print("Rate :)")
//                if !(self.player?.isPlaying)!
//                {
//                    timer.invalidate()
//                    self.IBimgBell.transform = CGAffineTransform(rotationAngle: 0)
//                }
//                else
//                {
//                    self.animateBell()
//                }
//            }
//        } else {
//            // Fallback on earlier versions
//        }
        //            self.animateTheLabels()
            self.openBucket()
            self.DriveMicUpAnimation()
            Timer.scheduledTimer(withTimeInterval: 0.6, repeats: false) { (timer) in
                self.DriveMicDownAnimation()
                timer.invalidate()
            }
    }
    
    func setBucketLayer()
    {
        self.bucketLid.setAnchorPoint(self.bucketLidAnchorPoint)
        self.bucketbody.setAnchorPoint(self.bucketLidAnchorPoint)
        

    }
    

    func openBucket() {
        let animation = CAKeyframeAnimation(keyPath: kLidOpeningKeyPath)

        animation.duration = animationDuration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        var timings: [AnyHashable] = []
        
        timings.append(animationTimingFunction)
        timings.append(animationTimingFunction)
        animation.values = [DegreesToRadians(degree: 0),DegreesToRadians(degree: CGFloat(self.degreesVariance))]
        animation.timingFunctions = timings as? [CAMediaTimingFunction]
        bucketLid.layer.add(animation, forKey: kLidOpeningKeyPath)
    }
    
    func closeBucket() {
        let animation = CAKeyframeAnimation(keyPath: kLidOpeningKeyPath)
        
        animation.duration = animationDuration
        animation.delegate = self
        animation.isRemovedOnCompletion = false
        animation.fillMode = kCAFillModeForwards
        var timings: [AnyHashable] = []
        timings.append(animationTimingFunction)
        timings.append(animationTimingFunction)
        animation.values = [DegreesToRadians(degree: CGFloat(self.degreesVariance)),DegreesToRadians(degree: 0)]
        animation.timingFunctions = timings as? [CAMediaTimingFunction]
        bucketLid.layer.add(animation, forKey: kLidOpeningKeyPath)
    }
    
    func DriveMicUpAnimation()
    {
        let moveUpanimation = CABasicAnimation(keyPath: "position")
        moveUpanimation.fromValue = NSValue( cgPoint: self.mic.layer.position)
        moveUpanimation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(self.mic.frame.midX), y: CGFloat(self.mic.frame.midY - kScrapDriveUpAnimationHeight)))
        moveUpanimation.isRemovedOnCompletion = false
        moveUpanimation.fillMode = kCAFillModeForwards
        moveUpanimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        
        let rotateMicanimation = CAKeyframeAnimation(keyPath: "transform")
        rotateMicanimation.values = [0.0, CGFloat.pi, CGFloat.pi * 1.5, CGFloat.pi * 2.0]
        rotateMicanimation.valueFunction =  CAValueFunction.init(name: kCAValueFunctionRotateZ)
        rotateMicanimation.isRemovedOnCompletion = false
        rotateMicanimation.fillMode = kCAFillModeForwards
        rotateMicanimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseOut)
        let groupAnim = CAAnimationGroup()
        groupAnim.animations = [moveUpanimation,rotateMicanimation]
        groupAnim.delegate = self
        groupAnim.setValue("scrap_drive_up_animation", forKey: "animation_name")
        groupAnim.duration = 0.6
        groupAnim.isRemovedOnCompletion = false
        groupAnim.fillMode = kCAFillModeForwards
        self.mic.layer.add(groupAnim, forKey: "DriveUpAnimation")
    }
    
    func DriveMicDownAnimation()
    {
        let driveDownanimation = CABasicAnimation(keyPath: "position")
        driveDownanimation.duration = 0.6
        driveDownanimation.toValue = NSValue(cgPoint: CGPoint(x: CGFloat(self.mic.layer.position.x), y: CGFloat(self.mic.layer.position.y + 200)))
        driveDownanimation.setValue("scrap_drive_down_animation", forKey: "animation_name")
        driveDownanimation.isRemovedOnCompletion = false
        driveDownanimation.fillMode = kCAFillModeForwards
        driveDownanimation.timingFunction = CAMediaTimingFunction.init(name: kCAMediaTimingFunctionEaseIn)
        driveDownanimation.delegate = self
        self.mic.layer.add(driveDownanimation, forKey: "DriveDownAnimation")
    }
    
    func animateTheLabels()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
            
            self.IBlblTitle.transform = CGAffineTransform(translationX: -30, y: 0)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.IBlblTitle.alpha = 0
                self.IBlblTitle.transform = self.IBlblTitle.transform.translatedBy(x: 0, y: -200)
            }) { (_) in
                
            }
        }
        
        UIView.animate(withDuration: 0.5, delay: 0.5, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.IBlblDescription.transform = CGAffineTransform(translationX: -30, y: 0)
        }) { (_) in
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.IBlblDescription.alpha = 0
                self.IBlblDescription.transform = self.IBlblDescription.transform.translatedBy(x: 0, y: -200)
            }) { (_) in
                self.resetTheLables()
            }
        }
    }
    
    func resetTheLables()
    {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.IBlblTitle.alpha = 1
            self.IBlblTitle.transform = self.IBlblDescription.transform.translatedBy(x: 0, y: 200)
            self.IBlblDescription.alpha = 1
            self.IBlblDescription.transform = self.IBlblDescription.transform.translatedBy(x: 0, y: 200)
            
            
        }) { (_) in
            
        }
    }
    
    
    func animateBell()
    {
        UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
            
            self.IBimgBell.transform = CGAffineTransform(rotationAngle: -0.15)
            
        }) { (finish) in
            UIView.animate(withDuration: 0.2, delay: 0.0, usingSpringWithDamping: 0.0, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                
                self.IBimgBell.transform = CGAffineTransform(rotationAngle: 0.15)
                
            }) { (finish) in
                
            }
        }
    }
    
    var player: AVAudioPlayer?
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "bell-ringing-01", withExtension: "mp3") else { return }
        
        do {
             try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            
            /* The following line is required for the player to work on iOS 11. Change the file type accordingly*/
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            /* iOS 10 and earlier require the following line:
             player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileTypeMPEGLayer3) */
            
            guard let player = player else { return }
            player.setVolume(1, fadeDuration: 5)
            
            
            
            player.play()
            
            
        } catch let error {
            print(error.localizedDescription)
        }
    }
    
    
    

}
@available(iOS 10.0, *)
extension AnimVC : CAAnimationDelegate
{
    func animationDidStart(_ anim: CAAnimation) {
        print("Did start animation")
    }
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        print("Animation did stop")
        if (anim.value(forKey: "animation_name") as? String) == "scrap_drive_down_animation"
        {
            self.closeBucket()
        }
        
    }
}
extension UIView {
    func setAnchorPoint(_ point: CGPoint) {
        var newPoint = CGPoint(x: bounds.size.width * point.x, y: bounds.size.height * point.y)
        var oldPoint = CGPoint(x: bounds.size.width * layer.anchorPoint.x, y: bounds.size.height * layer.anchorPoint.y);
        
        newPoint = newPoint.applying(transform)
        oldPoint = oldPoint.applying(transform)
        
        var position = layer.position
        
        position.x -= oldPoint.x
        position.x += newPoint.x
        
        position.y -= oldPoint.y
        position.y += newPoint.y
        
        layer.position = position
        layer.anchorPoint = point
    }
}
