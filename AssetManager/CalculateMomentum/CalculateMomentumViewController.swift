//
//  CalculateMomentumViewController.swift
//  AssetManager
//
//  Created by 정다연 on 8/26/24.
//

import UIKit
import RxSwift
import RxCocoa
import RxDataSources

class CalculateMomentumViewController: UIViewController {
    private let disposeBag = DisposeBag()
    var viewModel: CalculateMomentumViewModel!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        bind()
    }
    
    private func setupTableView() {
        tableView.register(
            cellTypes:
                [
                    UITableViewCell.self,
                    CalculateMomentumTitleCell.self
                ]
        )
    }
    
    private func bind() {
        viewModel.sections
            .drive(tableView.rx.items(dataSource: dataSource()))
            .disposed(by: disposeBag)
        
    }
}

extension CalculateMomentumViewController {
    private func dataSource() -> RxTableViewSectionedReloadDataSource<CalculateMomentumSectionModel> {
        return RxTableViewSectionedReloadDataSource<CalculateMomentumSectionModel>(configureCell: { [weak self] dataSource, table, idxPath, item in
            guard let self = self else { return UITableViewCell() }
            
            switch item {
                case let .calculate(viewModel):
                    return self.calculateCell(table: table, idxPath: idxPath, viewModel: viewModel)
            }
        })
    }
}

extension CalculateMomentumViewController {
    private func calculateCell(
        table: UITableView,
        idxPath: IndexPath,
        viewModel: CalculateMomentumTitleCellViewModel
    ) -> CalculateMomentumTitleCell {
        let cell: CalculateMomentumTitleCell = table.dequeueReusableCell(forIndexPath: idxPath)
        cell.bind(with: viewModel)
        return cell
    }
}
    
