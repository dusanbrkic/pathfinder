import UIKit

extension LocationSearchViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        matchingItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: LocationSearchCollectionViewCell.getReuseIdentifier(), for: indexPath) as! LocationSearchCollectionViewCell
        cell.setup(with: matchingItems[indexPath.item])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let placemark = matchingItems[indexPath.item].placemark
        searchDelegate?.dropPinZoomIn(placemark: placemark)
        self.searchController?.isActive = false
    }
}
