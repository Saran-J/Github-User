import UIKit
import Kingfisher

class RepoHeaderView: UIView {
    static let headerHeight: CGFloat = 120
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    
    func setupData(title: String, url: String, image: String) {
        titleLabel.text = title
        urlLabel.text = url
        urlLabel.sizeToFit()
        
        let processor = DownsamplingImageProcessor(size: avatarImageView.bounds.size)
        let url = URL(string: image)
        avatarImageView.kf.setImage(
            with: url,
            placeholder: UIImage(named: "placeholderImage"),
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
