module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)

import Components.Hello exposing ( helloBox )
import Components.Navbar exposing ( navbar )
import Components.Sponsors exposing ( sponsorGrid )


view : Model -> Html Msg
view model =
  div [][
    navbar "Main title"
    , section [ class "section" ][
      div [ class "columns" ][
        div [ class "column is-two-thirds" ][
          helloBox model.amount Msgs.Increment
        ]
        , div [ class "column" ][
          sponsorGrid model.sponsors
        ]
      ]
    ]
  ]
