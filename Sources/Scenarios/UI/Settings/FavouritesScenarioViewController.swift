//
//  File.swift
//  
//
//  Created by Tran Binh An on 31/1/25.
//

import Foundation
import SwiftUI
import UIKit
import MovableWindow

class FavouritesScenariosViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .black
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        view.addSubview(blurView)
        blurView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            blurView.topAnchor.constraint(equalTo: view.topAnchor),
            blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let closeImage = UIImage(systemName: "xmark")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let minimumImage = UIImage(systemName: "chevron.up")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)
        let resetImage = UIImage(systemName: "arrow.clockwise")?.withRenderingMode(.alwaysTemplate).withTintColor(.white)

        
        let titleLabel = UILabel()
        titleLabel.text = "Favourites"
        titleLabel.font = UIFont.systemFont(ofSize: 12)
        titleLabel.textColor = .lightGray
        titleLabel.textAlignment = .center
        view.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        let closeButton = UIButton()
        closeButton.tintColor = .white
        closeButton.setImage(closeImage, for: .normal)
        closeButton.addTarget(self, action: #selector(close), for: .touchUpInside)
        view.addSubview(closeButton)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 5),
            closeButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            closeButton.widthAnchor.constraint(equalToConstant: 20),
            closeButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let clearButton = UIButton()
        clearButton.tintColor = .white
        clearButton.setImage(resetImage, for: .normal)
        clearButton.addTarget(self, action: #selector(clear), for: .touchUpInside)
        view.addSubview(clearButton)
        clearButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            clearButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3),
            clearButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            clearButton.widthAnchor.constraint(equalToConstant: 20),
            clearButton.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        let minimumButton = UIButton()
        minimumButton.tintColor = .white
        minimumButton.contentMode = .scaleAspectFit
        minimumButton.setImage(minimumImage, for: .normal)
        minimumButton.addTarget(self, action: #selector(minimum), for: .touchUpInside)
        view.addSubview(minimumButton)
        minimumButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            minimumButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -3),
            minimumButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            minimumButton.widthAnchor.constraint(equalToConstant: 20),
            minimumButton.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    override func loadView() {
        let view = UIView()
        view.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 280)
        view.layer.cornerRadius = 12
        view.layer.masksToBounds = true
        self.view = view
    }

    @objc private func clear() {
        NotificationCenter.default.post(name: .resetScenario, object: nil)
    }

    @objc private func close() {
        self.view.window?.isHidden = true
    }
    
    @objc private func minimum() {
        if let window = self.view.window as? ScenariosMovableWindow {
            window.minimized = true
        }
    }
}
