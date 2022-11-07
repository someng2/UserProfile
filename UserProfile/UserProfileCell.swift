//
//  UserProfileCell.swift
//  UserProfile
//
//  Created by 백소망 on 2022/11/02.
//

import UIKit

class UserProfileCell: UITableViewCell {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setupView(user: User) {
        //이미지 리소스 받아오는 부분
        DispatchQueue.global(qos: .userInitiated).async {
            guard let imageURL = URL(string: user.picture.thumbnail) else {
                return
            }
            
            let request = URLRequest(url: imageURL)
            // 역시나 싱글턴 이용
            URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
                if let data = data, let response = response, ((response as? HTTPURLResponse)?.statusCode ?? 500) < 300, let image = UIImage(data: data) {
                    // 테이블뷰 리로드 하는 것과 마찬가지로 UI작업은 main 스레드에서 해줍니다
                    DispatchQueue.main.async {
                        self.transition(toImage: image)
                    }
                }
            }).resume()
        }
        
        nameLabel.text = user.name.full
        emailLabel.text =  user.email
    }
    
    // 이미지로딩이 자연스럽도록 설정
    func transition(toImage image: UIImage?) {
        UIView.transition(with: self, duration: 0.3,
                          options: [.transitionCrossDissolve],
                          animations: {
                            self.profileImageView.image = image
        },
                          completion: nil)
    }
}
