//
//  MusicHomeViewController.swift
//  one
//
//  Created by sidney on 5/19/21.
//

import UIKit
import MJRefresh

class MusicHomeViewController: BaseTableViewController {

    lazy var menuButton: UIButton = {
        let _menuButton = UIButton.getSystemIconBtn(name: "text.alignleft", color: .label)
        _menuButton.addTarget(self, action: #selector(showLeftVc), for: .touchUpInside)
        return _menuButton
    }()
    
    lazy var weatherButton: UIButton = {
        let _weatherButton = UIButton.getSystemIconBtn(name: "sun.max.fill", color: .label)
        _weatherButton.addTarget(self, action: #selector(changeInterfaceStyleMode), for: .touchUpInside)
        return _weatherButton
    }()
    
    lazy var topImageView: UIImageView = {
        let _topImageView = UIImageView()
        _topImageView.contentMode = .scaleAspectFill
        return _topImageView
    }()
    
    lazy var topView: UIView = {
        let _topView = UIView()
        _topView.addSubview(topImageView)
        topImageView.snp.makeConstraints { maker in
            maker.top.bottom.leading.trailing.equalToSuperview()
        }
        return _topView
    }()
    
    lazy var topShadowView: UIVisualEffectView = {
        let _topShadowView = UIVisualEffectView(effect: UIBlurEffect(style: ThemeManager.shared.getBlurStyle()))
        return _topShadowView
    }()
    
//    var header = MJRefreshNormalHeader()
    var footer = MJRefreshAutoNormalFooter()
    var posters: [MusicPoster] = []
    var functions: [MusicFunction] = []
    var recommendedMusics: [MusicSheet] = []
    var musics: [Music] = []
    var ktvs: [MusicKTV] = []
    
    override func viewDidLoad() {
        self.isTabBarVc = true
        setTableView()
        setNavigation()
        NotificationService.shared.listenInterfaceStyleChange(target: self, selector: #selector(changeInterfaceStyle))
        self.getData()
    }
    
    override func setNavigation() {
        super.setStatusBar()
        super.setNavigation()

        self.view.backgroundColor = .systemBackground
        self.view.addSubview(navigationView)
        navigationView.snp.makeConstraints { (maker) in
            maker.top.equalToSuperview().offset(STATUS_BAR_HEIGHT)
            maker.left.equalToSuperview().offset(0)
            maker.trailing.equalToSuperview().offset(0)
            maker.height.equalTo(44)
        }
        
        navigationView.addSubview(menuButton)
        menuButton.snp.makeConstraints({ (maker) in
            maker.centerY.equalToSuperview()
            maker.leading.equalToSuperview().offset(20)
        })
        
        navigationView.addSubview(weatherButton)
        weatherButton.snp.makeConstraints({ (maker) in
            maker.centerY.equalToSuperview()
            maker.trailing.equalToSuperview().offset(-20)
        })
        
        let transColor: UIColor = .clear
        self.statusBarView.backgroundColor = transColor
        self.navigationView.backgroundColor = transColor
    }
    
    func setTableView() {
        self.view.addSubview(topView)
        topView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(STATUS_NAV_HEIGHT + 180)
        }

        self.view.addSubview(topShadowView)
        topShadowView.snp.makeConstraints { (maker) in
            maker.top.leading.trailing.equalToSuperview()
            maker.height.equalTo(SCREEN_HEIGHT)
        }

        self.view.addSubview(self.tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.snp.makeConstraints { (maker) in
            maker.leading.trailing.bottom.equalToSuperview()
            maker.top.equalToSuperview().offset(hasNotch ? 88 : 64)
        }
        let header = CustomRefreshHeader1()
        tableView.mj_header = header
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = .clear
        header.setRefreshingTarget(self, refreshingAction: #selector(refreshData))
    }
    
    @objc func refreshData() {
        delay(1) {
            self.getData()
            self.tableView.mj_header?.endRefreshing()
        }
    }
    
    @objc func showLeftVc() {
        appDelegate.rootVc?.drawerVc.openLeftVc()
    }
    
    @objc func changeInterfaceStyle() {
        self.topShadowView.effect = UIBlurEffect(style: ThemeManager.shared.getBlurStyle())
    }
    
    @objc func changeInterfaceStyleMode() {
        ThemeManager.shared.changeWindowInterfaceStyle()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return tableData.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerData = tableData[section] as! MusicHomeSection
        let header = UIView()
        let padding: CGFloat = 10
        if section == 0 {
            let carousel = Carousel(images: headerData.items as! [MusicPoster])
            carousel.pageCallback = self.updateTopViewImage
            header.addSubview(carousel)
            carousel.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview().offset(15)
                maker.bottom.equalToSuperview().offset(-15)
                maker.leading.equalToSuperview().offset(15)
                maker.trailing.equalToSuperview().offset(-15)
            }
        }
        if section == 1 {
            let functionView = MusicFunctionView(functions: headerData.items as! [MusicFunction])
            header.addSubview(functionView)
            functionView.snp.makeConstraints { (maker) in
                maker.top.equalToSuperview().offset(padding)
                maker.bottom.equalToSuperview().offset(-padding)
                maker.leading.equalToSuperview().offset(padding)
                maker.trailing.equalToSuperview().offset(-padding)
            }
        }
        if section == 2 {
            let musicSheetView = MusicSheetView(musicSheets: headerData.items as! [MusicSheet], headerName: headerData.title)
            header.addSubview(musicSheetView)
            musicSheetView.snp.makeConstraints { maker in
                maker.top.equalToSuperview().offset(padding)
                maker.bottom.equalToSuperview().offset(-padding)
                maker.leading.equalToSuperview().offset(padding)
                maker.trailing.equalToSuperview().offset(-padding)
            }
        }
        if section == 3 {
            let musicListView = MusicListView(musics: headerData.items as! [Music], headerName: headerData.title)
            header.addSubview(musicListView)
            musicListView.snp.makeConstraints { maker in
                maker.top.equalToSuperview().offset(padding)
                maker.bottom.equalToSuperview().offset(-padding)
                maker.leading.equalToSuperview().offset(padding)
                maker.trailing.equalToSuperview().offset(-padding)
            }
        }
        if section == 4 {
            let musicKTVView = MusicKTVView(musicKTVs: headerData.items as! [MusicKTV], headerName: headerData.title)
            header.addSubview(musicKTVView)
            musicKTVView.snp.makeConstraints { maker in
                maker.top.equalToSuperview().offset(padding)
                maker.bottom.equalToSuperview().offset(-padding)
                maker.leading.equalToSuperview().offset(padding)
                maker.trailing.equalToSuperview().offset(-padding)
            }
        }
        return header
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 180
        }
        if section == 1 {
            return 80
        }
        if section == 2 {
            return 220
        }
        if section == 3 {
            return 260
        }
        if section == 4 {
            return 220
        }
        return .leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if section == 2 {
            return 12
        }
        if section == self.tableData.count - 1 {
            if let tabbarVc = appDelegate.rootVc?.drawerVc.tabbarVc {
                return tabbarVc.tabBarHeight + tabbarVc.musicControlBarHeight
            }
        }
        return .leastNormalMagnitude
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footer = UIView()
        return footer
    }
    
    func updateTopViewImage(pageIndex: Int) {
        if let url = URL(string: posters[pageIndex].url) {
            topImageView.loadFrom(url: url)
        }
    }
    
    func getData() {
        self.posters = []
        self.functions = []
        self.recommendedMusics = []
        self.musics = []
        self.ktvs = []
        self.tableData = []
        posters.append(MusicPoster(url: "https://i.loli.net/2021/05/26/BOs7DMaKW86TLc4.jpg", color: .gray))
        posters.append(MusicPoster(url: "https://i.loli.net/2021/05/26/rVnT7Sf1N3ICw9j.jpg", color: .blue))
        posters.append(MusicPoster(url: "https://i.loli.net/2021/05/26/XFqhaPOEY19rBAJ.jpg", color: .purple))
        tableData.append(MusicHomeSection(type: .poster, items: posters, title: ""))

        functions.append(MusicFunction(icon: "calendar", name: "每日推荐", to: ""))
        functions.append(MusicFunction(icon: "bus", name: "私人FM", to: ""))
        functions.append(MusicFunction(icon: "book", name: "歌单", to: ""))
        functions.append(MusicFunction(icon: "rank", name: "排行榜", to: ""))
        functions.append(MusicFunction(icon: "movie", name: "数字专辑", to: ""))
        functions.append(MusicFunction(icon: "voice", name: "歌房", to: ""))
        functions.append(MusicFunction(icon: "rmb", name: "游戏专区", to: ""))
        tableData.append(MusicHomeSection(type: .function, items: functions, title: ""))
        
        var posterUrlstrs: [String] = []
        for _ in 0..<4 {
            posterUrlstrs.append(MockService.shared.getRandomImg())
        }
        
        recommendedMusics.append(MusicSheet(name: "数尽荒芜过后 必定会有新生", id: "1", posters: posterUrlstrs, playCount: 0))
        recommendedMusics.append(MusicSheet(name: "今天从《千百度》听起 | 私人雷达", id: "2", posters: [MockService.shared.getRandomImg()], playCount: 0))
        recommendedMusics.append(MusicSheet(name: "全网畅销流行热歌", id: "3", posters: [MockService.shared.getRandomImg()], playCount: 0))
        recommendedMusics.append(MusicSheet(name: "让耳朵怀孕的抒情网络热歌", id: "4", posters: [MockService.shared.getRandomImg()], playCount: 0))
        recommendedMusics.append(MusicSheet(name: "渡过失恋期Cover集", id: "5", posters: [MockService.shared.getRandomImg()], playCount: 0))
        recommendedMusics.append(MusicSheet(name: "时间治愈的是 愿意自渡之人", id: "6", posters: [MockService.shared.getRandomImg()], playCount: 0))
        
        musics.append(Music(id: "1", poster: MockService.shared.getRandomImg(), name: "千百度", subtitle: "众里寻他千百度", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "2", poster: MockService.shared.getRandomImg(), name: "灰色头像", subtitle: "你灰色头不会在跳动", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "3", poster: MockService.shared.getRandomImg(), name: "幻听", subtitle: "如今一个人听歌总是会觉得失落", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "4", poster: MockService.shared.getRandomImg(), name: "城府", subtitle: "你的城府有多深", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "5", poster: MockService.shared.getRandomImg(), name: "断桥残雪", subtitle: "断桥是否下过雪，我望着湖面", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "6", poster: MockService.shared.getRandomImg(), name: "庐州月", subtitle: "庐州的月光在我心上", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "7", poster: MockService.shared.getRandomImg(), name: "星座书上", subtitle: "最后我偷偷把那页撕掉", playCount: 0, author: "许嵩"))
        musics.append(Music(id: "8", poster: MockService.shared.getRandomImg(), name: "违章动物", subtitle: "一群高贵气质的差人在处罚违章动物", playCount: 0, author: "许嵩"))
        
        ktvs.append(MusicKTV(roomColors: ["#a6c0fe", "#f68084"], roomId: "1", roomTitle: "难听歌房营业中", currentMusicName: "星辰大海 - 黄潇潇", currentImage: MockService.shared.getRandomImg(), roomUserNumber: 11))
        ktvs.append(MusicKTV(roomColors: ["#84fab0", "#8fd3f4"], roomId: "2", roomTitle: "嗯", currentMusicName: "小情歌 - 苏打绿", currentImage: MockService.shared.getRandomImg(), roomUserNumber: 5))
        ktvs.append(MusicKTV(roomColors: ["#f6d365", "#fda085"], roomId: "3", roomTitle: "在线满30人，送保时捷", currentMusicName: "寂寞的季节 - 陶喆", currentImage: MockService.shared.getRandomImg(), roomUserNumber: 3))
        ktvs.append(MusicKTV(roomColors: ["#48c6ef", "#6f86d6"], roomId: "4", roomTitle: "Our job is only to love", currentMusicName: "焰火青年 - 刘森", currentImage: MockService.shared.getRandomImg(), roomUserNumber: 102))
        ktvs.append(MusicKTV(roomColors: ["#a6c0fe", "#f68084"], roomId: "5", roomTitle: "随意", currentMusicName: "不该用情 - 柯积", currentImage: MockService.shared.getRandomImg(), roomUserNumber: 1))
        
        CacheManager.shared.preCache(urlstrs: posterUrlstrs) {
            self.tableData.append(MusicHomeSection(type: .musicSheet, items: self.recommendedMusics, title: "推荐歌单"))
            self.tableData.append(MusicHomeSection(type: .musicList, items: self.musics, title: "送你一壶古风酿的酒"))
            self.tableData.append(MusicHomeSection(type: .ktv, items: self.ktvs, title: "唱吧KTV"))
            self.tableView.reloadData()
        }
        self.updateTopViewImage(pageIndex: 0)
    }
}
