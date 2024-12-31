//
//  NewsDetailsController.swift
//  NASANews
//
//  Created by Haneen Medhat on 20/10/2024.
//

import UIKit
import SDWebImage

class NewsDetailsController: UITableViewController {
    
    var news : NewsInfo?
    var storedNews : [NewsInfo] = []
    @IBOutlet weak var newsImg: UIImageView!
    @IBOutlet weak var newsTitle: UILabel!
    @IBOutlet weak var newsAuthor: UILabel!
    @IBOutlet weak var newsDate: UILabel!
    @IBOutlet weak var newsDescrip: UITextView!
    @IBOutlet weak var saveBtnColor: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCell()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkColor()
    }
    
    // MARK: - Setup cell details
    func setupCell(){
        if let img = news?.image {
            newsImg.sd_setImage(with: URL(string: img), completed: nil)
        }else{
            newsImg.image = UIImage(named: "loading.png")
        }
        let title = news?.title ?? "No title found"
        newsTitle.text = title
        newsAuthor.text = news?.author ?? "No Author found"
        newsDate.text = news?.date ?? "No date found"
        newsDescrip.text = news?.description ?? "No description was found"
    }
    
    // MARK: - Handeling save button color
    func checkColor(){
         storedNews = DataStorage.fetchNewsPredicate(title: news?.title ?? "No title found")
        if storedNews.isEmpty {
            saveBtnColor.image = UIImage(systemName: "bookmark")
        }else{
            saveBtnColor.image = UIImage(systemName: "bookmark.fill")
        }
    }

    // MARK: - Save button handeling
    @IBAction func saveBtn(_ sender: UIBarButtonItem) {
        if storedNews.isEmpty {
        if let news = news{
        DataStorage.saveNews(news: news)

            saveBtnColor.image = UIImage(systemName: "bookmark.fill")
        } else{ return }
        }else{
            DataStorage.deleteNews(title:news?.title ?? "No title found")

            saveBtnColor.image = UIImage(systemName: "bookmark")
        }
    }
}
