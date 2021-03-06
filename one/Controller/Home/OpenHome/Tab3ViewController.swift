//
//  Tab3ViewController.swift
//  one
//
//  Created by sidney on 2021/6/14.
//

import UIKit

class Tab3ViewController: BaseCollectionViewController, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        collectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: getCollectionViewFlowLayout())
        super.viewDidLoad()
        collectionView.backgroundColor = .systemGray4
        collectionView.snp.remakeConstraints { (maker) in
            maker.leading.trailing.top.bottom.equalToSuperview()
        }
        registerNibWithName("PictureCollectionViewCell", collectionView: collectionView)
        registerNibWithName("LoadMoreCollectionReusableView", collectionView: collectionView, kind: UICollectionView.elementKindSectionFooter)
        self.headerRefresh()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PictureCollectionViewCell", for: indexPath) as! PictureCollectionViewCell
        cell.setCell(data: data[indexPath.row] as! Video)

        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let playerVc = PlayViewController()
        self.pushVc(vc: playerVc)
    }

//    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
//        switch kind {
//        case UICollectionView.elementKindSectionFooter:
//            let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "LoadMoreCollectionReusableView", for: indexPath) as! LoadMoreCollectionReusableView
//            return reusableView
//        default:
//            fatalError("Unexpected element kind")
//        }
//    }
    
    func collectionView(_ collectionView: UICollectionView,
                          layout collectionViewLayout: UICollectionViewLayout,
                          referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 60)
    }
    
    func updateCollectionView() {
        collectionView.performBatchUpdates {
            
        } completion: { (result) in
            print("performBatchUpdates: \(result)")
        }
    }
    
    override func getData() {
        super.getData()
        self.data = generateData()
    }
    
    override func loadData() {
        super.loadData()
        self.data.append(contentsOf: self.generateData())
    }
    
    func generateData() -> [Video] {
        var newData: [Video] = []
        for index in 0..<16 {
            newData.append(Video(id: "1", type: "1", title: "??????????????????????????????", subtitle: "???????????? ?? ????????????\(index)-", poster: MockService.shared.getRandomImg(), url: "https://blog.iword.win/langjie.mp4", avatar: MockService.shared.getRandomImg()))
        }
        return newData
    }

}
