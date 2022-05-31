import NFTRetrieval from "../contracts/NFTRetrieval.cdc"

pub struct NFT {
  pub let id : UInt64
  pub let name : String
  pub let description : String
  pub let thumbnail : String
  pub let externalURL : String
  pub let storagePath : StoragePath
  pub let publicPath : PublicPath
  pub let privatePath: PrivatePath
  pub let publicLinkedType: Type
  pub let privateLinkedType: Type
  pub let collectionName : String
  pub let collectionDescription: String
  pub let collectionSquareImage : String
  pub let collectionBannerImage : String

  init(
      id: UInt64,
      name : String,
      description : String,
      thumbnail : String,
      externalURL : String,
      storagePath : StoragePath,
      publicPath : PublicPath,
      privatePath : PrivatePath,
      publicLinkedType : Type,
      privateLinkedType : Type,
      collectionName : String,
      collectionDescription : String,
      collectionSquareImage : String,
      collectionBannerImage : String
  ) {
    self.id = id
    self.name = name
    self.description = description
    self.thumbnail = thumbnail
    self.externalURL = externalURL
    self.storagePath = storagePath
    self.publicPath = publicPath
    self.privatePath = privatePath
    self.publicLinkedType = publicLinkedType
    self.privateLinkedType = privateLinkedType
    self.collectionName = collectionName
    self.collectionDescription = collectionDescription
    self.collectionSquareImage = collectionSquareImage
    self.collectionBannerImage = collectionBannerImage
  }
}

pub fun main(ownerAddress: Address, collections: [String]) : { String : [NFT] }  {
  let nftCollections = NFTRetrieval.getNFTs(ownerAddress : ownerAddress)
  
  let data : {String : [NFT] } = {}

  for collection in collections {
    if nftCollections.containsKey(collection) {
      let nfts = nftCollections[collection]!
      let items : [NFT] = []
      
      for nft in nfts {
        let displayView = nft.display
        let externalURLView = nft.externalURL
        let collectionDataView = nft.collectionData
        let collectionDisplayView = nft.collectionDisplay
        if (displayView == nil || externalURLView == nil || collectionDataView == nil || collectionDisplayView == nil) {
          // Bad NFT. Skipping....
          continue
        }

        items.append(
          NFT(
            id: nft.id,
            name : displayView!.name,
            description : displayView!.description,
            thumbnail : displayView!.thumbnail.uri(),
            externalURL : externalURLView!.url,
            storagePath : collectionDataView!.storagePath,
            publicPath : collectionDataView!.publicPath,
            privatePath : collectionDataView!.providerPath,
            publicLinkedType : collectionDataView!.publicLinkedType,
            privateLinkedType : collectionDataView!.providerLinkedType,
            collectionName : collectionDisplayView!.name,
            collectionDescription : collectionDisplayView!.description,
            collectionSquareImage : collectionDisplayView!.squareImage.file.uri(),
            collectionBannerImage : collectionDisplayView!.bannerImage.file.uri(),
            )
          )
      }
      
      data[collection] = items
    }
  }

  return data
}