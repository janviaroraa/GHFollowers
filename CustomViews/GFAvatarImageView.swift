//
//  GFAvatarImageView.swift
//  GHFollowers
//
//  Created by Janvi Arora on 15/08/24.
//

import UIKit

class GFAvatarImageView: UIImageView {

    let placeholderImage = UIImage(named: SFSymbols.avatarLogo)
    var cache = NetworkManager.shared.cache

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 10
        clipsToBounds = true
        image = placeholderImage
    }

    func downloadImage(from urlString: String?) {
        guard let urlString,
              let url = URL(string: urlString) else { return }

        let cacheKey = NSString(string: urlString)

        if let image = cache.object(forKey: cacheKey) {
            self.image = image
            return
        }

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard error == nil,
                  let response = response as? HTTPURLResponse,
                  response.statusCode == 200,
                  let data else { return }

            guard let image = UIImage(data: data) else { return }
            self?.cache.setObject(image, forKey: cacheKey)

            DispatchQueue.main.async {
                self?.image = image
            }
        }.resume()
    }

    // Updated download func with async-await functionality
    func downloadImage(from urlString: String) {
        Task {
            image = await UpdatedNetworkManager.shared.downloadImage(from: urlString) ?? placeholderImage
        }
    }
}
