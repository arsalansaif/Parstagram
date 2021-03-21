//
//  FeedViewController.swift
//  Parstagram
//
//  Created by Arsalan Saif on 3/18/21.
//

import UIKit
import Parse
import AlamofireImage

var refreshControl: UIRefreshControl!

class FeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    func onRefresh() {
    }
    
    @IBOutlet var tableView: UITableView!
    var posts = [PFObject]()
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(onRefresh), forControlEvents: .valueChanged)
        scrollView.insertSubview(refreshControl, at: 0)
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let query = PFQuery(className: "Posts")
        query.includekey ("author")
        query.limit = 20
        query.findObjectsInBackground { (posts, error) in
            if posts != nil {
                self.posts = posts!
                self.tabbleView.reloadData()
            }
        }
    }
    func run(after wait: TimeInterval, closure: @escaping () -> Void) {
        let queue = DispatchQueue.main
        queue.asyncAfter(deadline: DispatchTime.now() + wait, execute: closure)
    }
    func refresh() {
        run(after: 2) {
           self.refreshControl.endRefreshing()
        }
    }
    func tableView(_ tableView: UITableView, numberofRowsInSection section: Int) -> Int {
        return posts.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
        IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell") as! PostCell
        let post = posts[indexPath.row]
        let user = post["author"] as! PFUser
        cell.usernameLabel.text = user.username
        cell.captionLabel.text = post["caption"] as! String
        let imageFile = post["image"] as! PFFileObject
        let urlString = imageFile.url!
        let url = URL(string: urlString)!
        cell.photoView.af_setImage(withURL: url)
        return cell
    }
}
