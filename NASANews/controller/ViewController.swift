//
//  ViewController.swift
//  NASANews
//
//  Created by Haneen Medhat on 15/10/2024.
//

import UIKit
import SDWebImage

class ViewController: UIViewController{
     
    var news : [NewsInfo] = []
    var networkServicePro : NetworkServiceProtocol?
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if networkServicePro == nil  {
          networkServicePro = MockNetworkService()
        }
        
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        getNews()
    }
    
    func getNews(){
        networkServicePro?.fetchData{
            (result : Result<[NewsInfo], Error>) in
                switch result {
                case .success(let response):
                    self.news = response
                    self.collectionView.reloadData()
                case .failure(let error):
                    print("Error fetching news! \(error.localizedDescription)")
             }
        }
    }
}
    extension ViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return news.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "newsCell", for: indexPath) as! NewsCell
        let newsObj = news[indexPath.row]
        cell.newsLabel.text = newsObj.title
        if let img = newsObj.image {
            cell.newsImage.sd_setImage(with: URL(string: img), placeholderImage: UIImage(named: "loading"), completed: nil)

        }else{
            cell.newsImage.image = UIImage(named: "loading")
        }
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "details") as! NewsDetailsController
        vc.news = news[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
        
    }
        
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let size = (collectionView.frame.size.width - 10) / 2
            return CGSize(width: size, height: size)
        }
    


}

