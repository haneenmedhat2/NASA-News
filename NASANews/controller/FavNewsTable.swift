//
//  FavNewsTable.swift
//  NASANews
//
//  Created by Haneen Medhat on 26/10/2024.
//

import UIKit
import SDWebImage

class FavNewsTable: UITableViewController {
    var imageIndicator : UIImageView!
    var news : [NewsInfo] = [] {
        didSet {
            setupIndicator()
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        news = DataStorage.fetchNews()
        tableView.reloadData()
    }
    
    func setupIndicator(){
        if imageIndicator == nil {
            imageIndicator = UIImageView(image: UIImage(named: "saved"))
            imageIndicator.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(imageIndicator)
            
            NSLayoutConstraint.activate([
                imageIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
                imageIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor , constant: -120),
                imageIndicator.widthAnchor.constraint(equalToConstant: 140),
                imageIndicator.heightAnchor.constraint(equalToConstant: 140),
                        ])
        }
        let isEmpty = news.isEmpty
        imageIndicator.isHidden = !isEmpty
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return news.count
    }
 
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavNewsCell
        let obj = news[indexPath.row]
        cell.newsTitle.text = obj.title
        if let img = obj.image {
        cell.favImg.sd_setImage(with: URL(string: img), completed: nil)
        }else{
            cell.favImg.image = UIImage(named: "loading")
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    
        return 220
    }
 
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let title = news[indexPath.row].title ?? "No title"
            DataStorage.deleteNews(title: title)
            news.remove(at:indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "details") as! NewsDetailsController
        vc.news = news[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
