//
//  ViewController.swift
//  Exercise C5
//
//  Created by Vladimir Terzievski on 12/29/20.
//

import UIKit
import SystemConfiguration

class ViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout
{
    //MARK: - Outlets
    
    @IBOutlet weak var mainCollectionView: UICollectionView!
    private var customLayout: UICollectionViewFlowLayout!
    //MARK: - Variables
    
    var myAlbums:[[Albums]] = []
    
    //MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showAlert()
        
        // Do any additional setup after loading the view.
        
        
        self.mainCollectionView.register(SectionHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        ApiCalls.shared.getAllAlbums { (albums, error) in
            ApiCalls.shared.getPhotos { (photos, error) in
                var helperAlbums:[Albums] = []
                if let albums = albums {
                    for album in albums {
                        if let photos = photos {
                            for photo in photos {
                                if album.id == photo.id {
                                    let album = album
                                    let photo = photo
                                    album.photo = photo
                                    helperAlbums.append(album)
                                }
                            }
                        }
                    }
                }
                self.myAlbums = helperAlbums.chunked(into: 10)
                self.mainCollectionView.reloadData()
            }
            self.mainCollectionView.dataSource = self
            self.mainCollectionView.delegate = self
        }
    }
    
    override func viewDidLayoutSubviews() {
        setCustomLayout()
    }
    
    //MARK: - Functions
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let sectionHeader = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as! SectionHeader
            let _ = myAlbums[indexPath.section][indexPath.row]
            sectionHeader.label.text = "\(indexPath.section)"
            return sectionHeader
        } else { //No footer in this case but can add option for that
            return UICollectionReusableView()
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: 22)
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return myAlbums.count
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return myAlbums[section].count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = myAlbums[indexPath.section][indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! CollectionViewCell
        cell.setup(album: album)
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let album = myAlbums[indexPath.section][indexPath.row]
        self.performSegue(withIdentifier: "fullscreen", sender: album)
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "fullscreen" {
            let album = sender as! Albums
            let controller = segue.destination as! FullScreenViewController
            controller.album = album
        }
    }
    func showAlert() {
        if !isInternetAvailable() {
            let alert = UIAlertController(title: "Warning", message: "Network is not available", preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default, handler: nil)
            alert.addAction(action)
            present(alert, animated: true, completion: nil)
        }
    }
    func isInternetAvailable() -> Bool
    {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    func setCustomLayout(){
        //CustomLayout
        customLayout = UICollectionViewFlowLayout()
        customLayout.minimumLineSpacing = 0
        customLayout.minimumInteritemSpacing = 0
        let screenWidth = UIScreen.main.bounds.width
        let scaleFactor = (screenWidth / 3) - 6
        customLayout.itemSize = CGSize(width: scaleFactor, height: scaleFactor)
        mainCollectionView?.collectionViewLayout = customLayout
        customLayout.scrollDirection = .vertical
        mainCollectionView.reloadData()
    }
    
}



extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
    }
}



class SectionHeader: UICollectionReusableView {
    var label: UILabel = {
        let label: UILabel = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 16, weight: .semibold)
        label.sizeToFit()
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(label)
        
        label.translatesAutoresizingMaskIntoConstraints = false
        label.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        label.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 20).isActive = true
        label.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
