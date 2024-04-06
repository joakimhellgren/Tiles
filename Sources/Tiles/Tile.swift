import UIKit

public class Tile: UIView {
    public var index: Int
    
    public var isPressed: Bool = false {
        didSet {
            didPress()
        }
    }
    
    public var latch: Bool = false {
        didSet {
            didLatch()
        }
    }
    
    public var isSelected: Bool = false {
        didSet {
            didSelect()
        }
    }
    
    required public init(
        frame: CGRect,
        index: Int,
        isPressed: Bool = false,
        latch: Bool = false,
        isSelected: Bool = false
    ) {
        self.index = index
        self.latch = latch
        self.isPressed = isPressed
        self.isSelected = isSelected
        
        super.init(frame: frame)
        self.configure()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func configure() {}
    open func didPress() {}
    open func didLatch() {}
    open func didSelect() {}
}

public class SolidTile: Tile {
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 7, y: 7, width: 100, height: 15))
        label.adjustsFontSizeToFitWidth = true
        label.text = "\(index)"
        label.textColor = .label
        return label
    }()
    
    private var fillColor: UIColor {
        isPressed ? .link : latch ? .tertiaryLabel : .secondarySystemBackground
    }
    
    private var borderWidth: CGFloat {
        isSelected ? 3.0 : 1.0
    }
    
    private var labelColor: UIColor {
        fillColor.luminance > 0.6 ? .black : .white
    }
    
    public override func didPress() {
        backgroundColor = fillColor
    }
    
    public override func didLatch() {
        backgroundColor = fillColor
    }
    
    public override func didSelect() {
        layer.borderWidth = borderWidth
    }
    
    public override func configure() {
        self.backgroundColor = fillColor
        self.layer.borderColor = UIColor.secondaryLabel.cgColor
        self.layer.borderWidth = borderWidth
        
        let label = UILabel(frame: CGRect(x: 7, y: 7, width: 100, height: 15))
        label.adjustsFontSizeToFitWidth = true
        label.text = "\(index)"
        label.textColor = .label
        self.addSubview(label)
    }
}

public class VibrantTile: Tile {
    private let blurEffect = UIBlurEffect(style: .prominent)
    
    private lazy var vibrancyEffectView: UIVisualEffectView = {
        let vibrancyEffect = UIVibrancyEffect(blurEffect: blurEffect)
        return UIVisualEffectView(effect: vibrancyEffect)
    }()
    
    private lazy var blurredEffectView: UIVisualEffectView = {
        return UIVisualEffectView(effect: blurEffect)
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 7, y: 7, width: 100, height: 15))
        label.adjustsFontSizeToFitWidth = true
        label.text = "\(index)"
        label.textColor = .label
        return label
    }()
    
    private var fillColor: UIColor {
        isPressed ? .link : latch ? .secondaryLabel : .secondarySystemBackground
    }
    
    private var borderWidth: CGFloat {
        isSelected ? 3.0 : 1.0
    }
    
    private var labelColor: UIColor {
        fillColor.luminance > 0.6 ? .black : .white
    }
    
    private var borderColor: UIColor {
        isSelected ? .link : .secondaryLabel
    }
    
    public override func configure() {
        blurredEffectView.frame = bounds
        vibrancyEffectView.frame = bounds
        
        vibrancyEffectView.contentView.backgroundColor = fillColor
        vibrancyEffectView.contentView.layer.borderColor = borderColor.cgColor
        vibrancyEffectView.contentView.layer.borderWidth = borderWidth
        
        blurredEffectView.contentView.addSubview(vibrancyEffectView)
        blurredEffectView.contentView.addSubview(label)
        
        addSubview(blurredEffectView)
    }
 
    public override func didPress() {
        vibrancyEffectView.contentView.backgroundColor = fillColor
    }
    
    public override func didLatch() {
        vibrancyEffectView.contentView.backgroundColor = fillColor
    }
    
    public override func didSelect() {
        vibrancyEffectView.contentView.layer.borderWidth = borderWidth
        vibrancyEffectView.contentView.layer.borderColor = borderColor.cgColor
    }
}



/*
 import UIKit

 open class Tile: UIView {
     public var index: Int {
         didSet {
             label.text = "\(index)"
         }
     }
     
     open lazy var label: UILabel = {
         let label = UILabel()
         label.textAlignment = .natural
         label.text = "\(index)"
         label.adjustsFontSizeToFitWidth = true
         label.textColor = labelColor
         label.frame = CGRect(x: frame.width*0.05, y: frame.height*0.05,
                              width: frame.width-frame.width*0.05, height: 20)
         return label
     }()
     
     open var color: UIColor {
         isPressed ? .label : isSelected ? .red : latch ? .link : .separator
     }
     
     open var labelColor: UIColor {
         color.luminance > 0.6 ? .black : .white
     }
     
     public var isPressed: Bool = false {
         didSet {
             backgroundColor = color
             label.textColor = labelColor
             didPress()
         }
     }
     
     public var latch: Bool = false {
         didSet {
             backgroundColor = color
             label.textColor = labelColor
             didLatch()
         }
     }
     
     public var isSelected: Bool = false {
         didSet {
             backgroundColor = color
             label.textColor = labelColor
             didSelect()
         }
     }
     
     required public init(
         frame: CGRect,
         index: Int,
         isPressed: Bool = false,
         latch: Bool = false,
         isSelected: Bool = false
     ) {
         self.index = index
         self.latch = latch
         self.isPressed = isPressed
         self.isSelected = isSelected
         super.init(frame: frame)
         self.addSubview(label)
         self.backgroundColor = color
     }
     
     required public init?(coder: NSCoder) {
         fatalError("init(coder:) has not been implemented")
     }
     
     open func didPress() {}
     open func didLatch() {}
     open func didSelect() {}
 }

 */
