module Msgs exposing (..)

import Navigation exposing ( Location )
import RemoteData exposing ( WebData )
import Models exposing ( Info, Sponsor, NewsItem, NewsId )

type Msg
  = NoOp
  | Increment
  | ChangeLocation String
  | OnLocationChange Location
  | OnFetchSponsors (WebData (List Sponsor))
  | OnFetchInfo (WebData Info)
  | OnFetchNewsList (WebData (List NewsItem))
  | OnFetchSingleNewsStory NewsId (WebData NewsItem)
