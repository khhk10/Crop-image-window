import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var cutWindow: UIView!
    
    var inputImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // let context = CIContext()
        
        // CIImage生成
        /*
        guard let filePath = Bundle.main.path(forResource: "grayscale", ofType: "jpg") else {
            // パスなし
            return
        }
        let url = URL(fileURLWithPath: filePath)
         */
        inputImage = UIImage(named: "grayscale")
        if inputImage == nil {
            return
        }
        
        /*
        // 切り抜き
        let cropRect = CGRect(x: 0, y: 0, width: 400, height: 200)
        guard let cutImage = inputImage.cgImage?.cropping(to: cropRect) else {
            return
        }
         */
        
        // UIImage生成
        // let image = UIImage(cgImage: cutImage)
        // print("#after (width: \(image.size.width), height: \(image.size.height))")
        
        // imageViewに表示
        // imageView.frame = CGRect(x: 0, y: 254, width: image.size.width, height: image.size.height)
        // imageView.frame.size = CGSize(width: 414, height: 300)
        // imageView.contentMode = .scaleAspectFit
        imageView.image = inputImage
        // imageView.isHidden = true
        
        // 切り抜き窓
        cutWindow = UIView()
        cutWindow.frame = CGRect(x: 50, y: 50, width: 200, height: 200)
        cutWindow.backgroundColor = .lightGray
        cutWindow.alpha = 0.4
        cutWindow.isUserInteractionEnabled = true
        let dragGesture = UIPanGestureRecognizer(target: self, action: #selector(dragWindow(_:)))
        imageView.addGestureRecognizer(dragGesture)
        
        imageView.addSubview(cutWindow)
        imageView.isUserInteractionEnabled = true
        
        print("image size : \(imageView.image!.size)")
    }
    
    // 切り抜き窓をドラッグした
    @objc func dragWindow(_ sender: UIGestureRecognizer) {
        var location = sender.location(in: imageView)
        print("location : \(location)")
        
        let threshold: Float = 50.0
        
        // ウィンドウの座標を制限
        if location.y <= 0 {
            location.y = 0
        } else if location.y >= imageView.frame.size.height {
            location.y = imageView.frame.size.height
        }
        
        if location.x <= 0 {
            location.x = 0
        } else if location.x >= imageView.frame.size.width {
            location.x = imageView.frame.size.width
        }
        
        // フレームの右側
        if fabsf(Float(location.x) - Float(cutWindow.frame.maxX)) <= threshold {
            // 右のx座標が、左のx座標を超えないようにする
            if location.x <= cutWindow.frame.minX {
                location.x = cutWindow.frame.minX + 30
            }
            
            if fabsf(Float(location.y) - Float(cutWindow.frame.maxY)) <= threshold && location.y > cutWindow.frame.minY {
                // 下のy座標が、上のy座標を超えないようにする
                if location.y <= cutWindow.frame.minY {
                    location.y = cutWindow.frame.minY + 30
                }
                
                let w = location.x - cutWindow.frame.minX
                let h = location.y - cutWindow.frame.minY
                cutWindow.frame.size = CGSize(width: w, height: h)
                print("右下をドラッグ")
                
            } else if fabsf(Float(location.y) - Float(cutWindow.frame.minY)) <= threshold {
                // 右のx座標が、左のx座標を超えないようにする
                if location.y >= cutWindow.frame.maxY {
                    location.y = cutWindow.frame.maxY - 30
                }
                
                let w = location.x - cutWindow.frame.origin.x
                let h = cutWindow.frame.maxY - location.y
                cutWindow.frame.origin.y = location.y
                cutWindow.frame.size = CGSize(width: w, height: h)
                print("右上をドラッグ")
    
            }
        
        //フレームの左側
        } else if fabsf(Float(location.x) - Float(cutWindow.frame.minX)) <= threshold {
            // 左のx座標が右のx座標を超えないようにする
            if location.x >= cutWindow.frame.maxX {
                location.x = cutWindow.frame.maxX - 30
            }
            
            if fabsf(Float(location.y) - Float(cutWindow.frame.maxY)) <= threshold {
                // 下のy座標が、上のy座標を超えないようにする
                if location.y <= cutWindow.frame.minY {
                    location.y = cutWindow.frame.minY + 30
                }
                
                let w = cutWindow.frame.maxX - location.x
                let h = location.y - cutWindow.frame.origin.y
                cutWindow.frame.origin.x = location.x
                cutWindow.frame.size = CGSize(width: w, height: h)
                print("左下をドラッグ")
                
            } else if fabsf(Float(location.y) - Float(cutWindow.frame.minY)) <= threshold {
                // 右のx座標が、左のx座標を超えないようにする
                if location.y >= cutWindow.frame.maxY {
                    location.y = cutWindow.frame.maxY - 30
                }
                
                let w = cutWindow.frame.maxX - location.x
                let h = cutWindow.frame.maxY - location.y
                cutWindow.frame.origin = CGPoint(x: location.x, y: location.y)
                cutWindow.frame.size = CGSize(width: w, height: h)
                print("左上をドラッグ")
            }
        }

    }
    
    @IBAction func cropImage(_ sender: UIButton) {
        let cutRect = cutWindow.frame
        let scale = max(inputImage!.size.width / imageView.frame.size.width, inputImage!.size.height / imageView.frame.size.height)
        // 切り抜き
        let point = CGPoint(x: cutRect.origin.x * scale, y: cutRect.origin.y * scale)
        let size = CGSize(width: cutRect.size.width * scale, height: cutRect.size.height * scale)
        let cropRect = CGRect(origin: point, size: size)
        
        guard let cutImage = inputImage!.cgImage?.cropping(to: cropRect) else {
            return
        }
        imageView.image = UIImage(cgImage: cutImage)
    }

}

