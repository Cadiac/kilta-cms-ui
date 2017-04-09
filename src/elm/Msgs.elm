module Msgs exposing (..)

import Http

import Components.Sponsors exposing ( Sponsor )
import Models exposing ( Info )

type Msg
  = NoOp
  | Increment
  | FetchSponsors (Result Http.Error (List Sponsor))
  | FetchInfo (Result Http.Error Info)
