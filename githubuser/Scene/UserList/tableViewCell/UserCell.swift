import UIKit
import Kingfisher

class UserCell: UITableViewCell {
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var isFavorite = false {
        didSet {
            if isFavorite {
                favoriteButton.setImage(
                    UIImage(named: "favorite"),
                    for: .normal)
            } else {
                favoriteButton.setImage(
                    UIImage(named: "unfavorite"),
                    for: .normal)
            }
        }
    }
    
    var onFavorite: ((Bool) -> Void) = { _ in }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func downloadImage(imageUrl: String) {
        let processor = DownsamplingImageProcessor(size: avatarImageView.bounds.size)
        let url = URL(string: imageUrl)
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
    
    @IBAction func onClickFavorite() {
        isFavorite.toggle()
        self.onFavorite(isFavorite)
    }
}
