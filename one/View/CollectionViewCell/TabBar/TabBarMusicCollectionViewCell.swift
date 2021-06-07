//
//  TabBarMusicCollectionViewCell.swift
//  one
//
//  Created by sidney on 6/7/21.
//

import UIKit

class TabBarMusicCollectionViewCell: BaseCollectionViewCell {
    @IBOutlet weak var bkgView: UIView!
    @IBOutlet weak var posterOuterView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var musicNameLabel: UILabel!
    @IBOutlet weak var musicAuthorLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.posterOuterView.layer.cornerRadius = self.posterOuterView.bounds.width / 2
        AnimationUtils.addRotate(layer: posterImageView.layer)
    }

    func setContent(data: Music) {
        self.musicNameLabel.text = data.name
        self.musicAuthorLabel.text = data.author
        if let url = URL(string: data.poster) {
            posterImageView.loadFrom(url: url, isCircle: true, contentMode: .scaleAspectFill)
            AnimationUtils.resetRotate(layer: posterImageView.layer)
        }
        NotificationService.shared.listenMusicStatus(target: self, selector: #selector(musicStatusChange))
    }
    
    @objc func musicStatusChange() {
        if MusicService.shared.isPlaying {
            AnimationUtils.resumeRotate(layer: posterImageView.layer)
        } else {
            AnimationUtils.pauseRotate(layer: posterImageView.layer)
        }
    }
}