// This Source Code Form is subject to the terms of the Mozilla Public
// License, v. 2.0. If a copy of the MPL was not distributed with this
// file, You can obtain one at http://mozilla.org/MPL/2.0/

import Common
import UIKit

typealias HomepageSection = HomepageDiffableDataSource.HomeSection
typealias HomepageItem = HomepageDiffableDataSource.HomeItem

/// Holds the data source configuration for the new homepage as part of the rebuild project
final class HomepageDiffableDataSource:
    UICollectionViewDiffableDataSource<HomepageSection, HomepageItem> {
    enum HomeSection: Int, Hashable {
        case header
        case topSites
        case pocket
        case customizeHomepage
    }

    enum HomeItem: Hashable {
        case header
        case topSite(TopSiteState)
        case topSiteEmpty
        case pocket(PocketStoryState)
        case pocketDiscover
        case customizeHomepage

        static var cellTypes: [ReusableCell.Type] {
            return [
                HomepageHeaderCell.self,
                TopSiteCell.self,
                EmptyTopSiteCell.self,
                PocketStandardCell.self,
                PocketDiscoverCell.self,
                CustomizeHomepageSectionCell.self
            ]
        }
    }

    func applyInitialSnapshot(state: HomepageState) {
        var snapshot = NSDiffableDataSourceSnapshot<HomeSection, HomeItem>()

        snapshot.appendSections([.header, .topSites, .pocket, .customizeHomepage])
        snapshot.appendItems([.header], toSection: .header)
        snapshot.appendItems([], toSection: .topSites)

        let topSites: [HomeItem] = state.topSitesState.topSitesData.compactMap { .topSite($0) }
        snapshot.appendItems(topSites, toSection: .topSites)

        let stories: [HomeItem] = state.pocketState.pocketData.compactMap { .pocket($0) }
        snapshot.appendItems(stories, toSection: .pocket)
        snapshot.appendItems([.pocketDiscover], toSection: .pocket)

        snapshot.appendItems([], toSection: .pocket)
        snapshot.appendItems([.customizeHomepage], toSection: .customizeHomepage)

        apply(snapshot, animatingDifferences: true)
    }
}
