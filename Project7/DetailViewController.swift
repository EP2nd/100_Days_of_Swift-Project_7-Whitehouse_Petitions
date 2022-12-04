//
//  DetailViewController.swift
//  Project7
//
//  Created by Edwin Przeźwiecki Jr. on 28/04/2022.
//

import UIKit
import WebKit

class DetailViewController: UIViewController {
    
    var webView: WKWebView!
    var detailItem: Petition?
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        guard let detailItem = detailItem else { return }
        
        /// Challenge 3:
        let html = """
<html>
<body style="background-color:powderblue;">
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style> body {font-size: 120%; } </style>
</head>
<body>
<h1>\(detailItem.title)</h1>
<p>\(detailItem.body)</p>
</body>
</html>
"""
        
        webView.loadHTMLString(html, baseURL: nil)
    }
}
