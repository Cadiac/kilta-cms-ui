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
  div [ class "column is-one-third", style styles.column ] [
    figure [ class "image is-64x64", style styles.logo ][
      a [ href sponsor.website ][
        img [ alt sponsor.name, src sponsor.logo ][]
      ]
    ]
  ]

sponsorGrid : List Sponsor -> Html msg
sponsorGrid sponsors =
  div [ class "box" ] [
    div [ class "heading" ] [
      h1 [ class "subtitle", style styles.heading ] [
        text "Yhteistyökumppanit"
      ]
    ]
    , div [ class "columns is-multiline is-mobile" ] (
      List.map sponsorItem sponsors
    )
  ]

-- CSS

type alias Style =
  List ( String, String )

styles : { heading : Style, column : Style, logo : Style }
styles =
  {
    heading =
      [ ( "display", "flex" )
      , ( "justify-content", "space-around")
      ],
    column =
      [ ( "display", "flex" )
      , ( "justify-content", "space-around")
      ],
    logo =
      [ ( "display", "flex" )
      , ( "align-items", "center")
      ]
  }
