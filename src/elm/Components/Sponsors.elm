module Components.Sponsors exposing (sponsorGrid, Sponsor)

import Html exposing (..)
import Html.Attributes exposing (..)


-- MODEL

type alias Sponsor =
  { name : String
  , website : String
  , logo: String
  }


-- VIEW

sponsorItem : Sponsor -> Html msg
sponsorItem sponsor =
  div [] [
    text ( sponsor.name )
  ]

sponsorGrid : List Sponsor -> Html msg
sponsorGrid sponsors =
  div [ class "box" ] (
    List.map sponsorItem sponsors
  )
