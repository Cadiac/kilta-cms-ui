module Msgs exposing (..)

import RemoteData exposing ( WebData )
import Models exposing ( Info, Sponsor )

type Msg
  = NoOp
  | Increment
  | OnFetchSponsors (WebData (List Sponsor))
  | OnFetchInfo (WebData Info)
