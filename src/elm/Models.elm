module Models exposing (..)

import Components.Sponsors exposing ( Sponsor )
import Types exposing ( Info, Flags )

type alias Model =
  { info : Info
  , sponsors : List Sponsor
  , amount : Int
  , config : Flags
  }
