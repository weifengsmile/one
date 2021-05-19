//
//  MusicHomeModel.swift
//  one
//
//  Created by sidney on 5/19/21.
//

import Foundation
import UIKit

enum MusicSection: String {
    case poster = "poster"
    case function = "function"
    case album = "album"
    case musicList = "musicList"
    case featureVideos = "featureVideos"
    case rank = "rank"
    case ktv = "ktv"
    case podcast = "podcast"
}

struct MusicHomeSection {
    var type: MusicSection = .poster
    var items: [MusicHomeItem] = []
    var title: String = ""
    
}

struct MusicHomeItem {
    var posters: [MusicPoster] = []
}

struct MusicPoster {
    var url: String = ""
    var color: UIColor = .white
}

struct Music {
    var poster: String = ""
    var name: String = ""
    var subtitle: String = ""
    var playCount: Int = 0
    var author: String = ""
}

