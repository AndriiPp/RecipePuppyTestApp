//
//  RecipeCell.swift
//  RecipePuppyTestApp
//
//  Created by Pyvovarov Andrii on 29.02.18.
//  Copyright © 2018 Pyvovarov Andrii. All rights reserved.
//

import UIKit

class RecipeCell: UITableViewCell {
    
    @IBOutlet weak var imageToRecipe: UIImageView!
    @IBOutlet weak var titleToRecipe: UILabel!
    @IBOutlet weak var ingredientsToRecipe: UILabel!
    
    func configureCell(_ recipe: Recipe) {
        titleToRecipe.text = recipe.title?.replacingOccurrences(of: "\n", with: "")
        ingredientsToRecipe.text = recipe.ingredients
        imageToRecipe.image = UIImage(named: "download")
        
        imageToRecipe.layer.cornerRadius = imageToRecipe.bounds.height / 2
        imageToRecipe.layer.borderWidth = 1.0
        imageToRecipe.layer.borderColor = UIColor.black.cgColor
        imageToRecipe.clipsToBounds = true
        
        if let thumbnail = recipe.thumbnail, thumbnail != "" {
            DispatchQueue.global(qos: .background).async {
                let imageUrl = URL(string: thumbnail)
                let imageData = try? Data(contentsOf: imageUrl!)
                DispatchQueue.main.async {
                    if let data = imageData {
                        self.imageToRecipe.image = UIImage(data: data)
                    } else {
                        self.imageToRecipe.image = UIImage(named: "notFoundImage")
                    }
                }
            }
        } else {
            imageToRecipe.image = UIImage(named: "notFoundImage")
        }
    }
    
}
