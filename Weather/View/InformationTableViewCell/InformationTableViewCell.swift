//
//  InformationTableViewCell.swift
//  Weather
//
//  Created by Pam Wongkraivet on 04.05.2023.
//

import UIKit

struct InformationTableViewCellViewModel {
    let informationLabelString: String?
}

final class InformationTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var informationLabel: UILabel!
    
    private var weatherModel: WeatherModel?
    static let identifier = "InformationTableViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    static func nib() -> UINib {
        return UINib(nibName: "InformationTableViewCell",
                     bundle: nil)
    }
    
    func configure(model: WeatherModel) {
        self.weatherModel = model
    }
    
//This is where the quote should be
    //func configureTableViewCellViewModelFor(_ index: Int, completionHandler: @escaping (InformationTableViewCellViewModel) -> Void) -> InformationTableViewCellViewModel {
    func configureTableViewCellViewModelFor(_ index: Int) -> InformationTableViewCellViewModel {
        let apiManager = QuotesAPIManager();
        Task {
            do {
                let optionalQuote = try await apiManager.fetchRandomQuote3()
                guard let quote = optionalQuote else {
                    return(InformationTableViewCellViewModel(informationLabelString: "something went wrong"))
                }
                debugPrint("called back")
                debugPrint(quote)
                return(InformationTableViewCellViewModel(informationLabelString: quote))
            } catch {
                return(InformationTableViewCellViewModel(informationLabelString: "something went wrong"))
            }
        }
        return(InformationTableViewCellViewModel(informationLabelString: "quote is loading"))
    }
    
    func setupCell(_ viewModel: InformationTableViewCellViewModel) {
        informationLabel.text = viewModel.informationLabelString
    }
    
}
