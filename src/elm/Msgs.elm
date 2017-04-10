module Msgs exposing (..)

import Navigation exposing ( Location )
import RemoteData exposing ( WebData )
import Models exposing ( Info, Sponsor, NewsItem )

type Msg
  = NoOp
  | Increment
  | OnLocationChange Location
  | OnFetchSponsors (WebData (List Sponsor))
  | OnFetchInfo (WebData Info)
  | OnFetchNews (WebData (List NewsItem))
