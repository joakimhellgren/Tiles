import UIKit

public protocol TileDelegate: AnyObject {
    func didPressTile(_ tile: Tile)
    func didLatchTile(_ tile: Tile)
    func didSelectTile(_ tile: Tile)
}

open class Tile: UIView {
    public var index: Int
    public weak var delegate: TileDelegate?
    
    open lazy var label: UILabel = {
        let label = UILabel()
        label.textAlignment = .natural
        label.text = "\(index)"
        label.adjustsFontSizeToFitWidth = true
        label.textColor = color.luminance > 0.6 ? .black : .white
        label.frame = CGRect(x: frame.width*0.05, y: frame.height*0.05, width: frame.width-frame.width*0.05, height: 20/*frame.height-frame.height*0.05*/)
        return label
    }()
    
    open var color: UIColor {
        isPressed ? .label : isSelected ? .red : latch ? .link : .separator
    }
    
    open var textColor: UIColor {
        color.luminance > 0.6 ? .black : .white
    }
    
    public var isPressed: Bool = false {
        didSet {
            backgroundColor = color
            label.textColor = textColor
            
            delegate?.didPressTile(self)
            didPress()
        }
    }
    
    public var latch: Bool = false {
        didSet {
            backgroundColor = color
            label.textColor = textColor
            
            delegate?.didLatchTile(self)
            didLatch()
        }
    }
    
    public var isSelected: Bool = false {
        didSet {
            backgroundColor = color
            label.textColor = textColor
            
            delegate?.didSelectTile(self)
            didSelect()
        }
    }
    
    required public init(
        frame: CGRect,
        index: Int,
        isPressed: Bool = false,
        latch: Bool = false,
        isSelected: Bool = false,
        delegate: TileDelegate? = nil
    ) {
        self.index = index
        self.latch = latch
        self.isPressed = isPressed
        self.isSelected = isSelected
        self.delegate = delegate
        super.init(frame: frame)
        
        label.textColor = textColor
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
