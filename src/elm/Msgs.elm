module Msgs exposing (..)

import RemoteData exposing ( WebData )
import Models exposing ( Info, Sponsor, NewsItem )

type Msg
  = NoOp
  | Increment
  | OnFetchSponsors (WebData (List Sponsor))
  | OnFetchInfo (WebData Info)
  | OnFetchNews (WebData (List NewsItem))
