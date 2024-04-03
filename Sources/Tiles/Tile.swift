import UIKit

public protocol TileDelegate: AnyObject {
    func didPressTile(at index: Int, isPressed: Bool)
    func didLatchTile(at index: Int, isLatched: Bool)
}

open class Tile: UIView {
    public var index: Int
    public weak var delegate: TileDelegate?
    
    public var isPressed: Bool = false {
        willSet {
            if newValue, !isPressed {
                delegate?.didPressTile(at: index, isPressed: true)
            } else if !newValue, isPressed {
                delegate?.didPressTile(at: index, isPressed: false)
            }
        }
        
        didSet {
            didPress(isPressed)
        }
    }
    
    public var latch: Bool = false {
        willSet {
            if newValue, !latch {
                delegate?.didLatchTile(at: index, isLatched: true)
            } else if !newValue, latch {
                delegate?.didLatchTile(at: index, isLatched: false)
            }
        }
        
        didSet {
            didLatch(latch)
        }
    }
    
    public var isSelected: Bool = false {
        didSet {
            backgroundColor = isSelected ? .red : color
        }
    }
    
    required public init(frame: CGRect, index: Int, isPressed: Bool = false, latch: Bool = false, isSelected: Bool = false, delegate: TileDelegate? = nil) {
        self.index = index
        self.latch = latch
        self.isPressed = isPressed
        self.isSelected = isSelected
        self.delegate = delegate
        super.init(frame: frame)
        
        self.backgroundColor = color
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open var color: UIColor {
        isPressed ? .label : isSelected ? .red : latch ? .link : .separator
    }
    
    open func didPress(_ isPressed: Bool) {}
    open func didLatch(_ isLatched: Bool) {}
}

open class BasicTile: Tile {
    open lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.text = "\(index)"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = color.luminance > 0.6 ? .black : .white
        label.frame = CGRect(x: frame.width*0.05, y: frame.height*0.05, width: frame.width-frame.width*0.05, height: 20/*frame.height-frame.height*0.05*/)
        return label
    }()
    
    required public init(
        frame: CGRect,
        index: Int,
        isPressed: Bool = false,
        latch: Bool = false,
        isSelected: Bool = false,
        delegate: TileDelegate? = nil
    ) {
        super.init(frame: frame, index: index, isPressed: isPressed, latch: latch, isSelected: isSelected, delegate: delegate)
        self.backgroundColor = isSelected ? .red : color
        self.addSubview(label)
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    override open func didPress(_ isPressed: Bool) {
        backgroundColor = color
        label.textColor = color.luminance > 0.6 ? .black : .white
    }
}

