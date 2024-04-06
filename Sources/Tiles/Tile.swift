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
