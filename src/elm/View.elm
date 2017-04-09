module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)

import Components.Hello
import Components.Navbar
import Components.Sponsors


view : Model -> Html Msg
view model =
  div [][
    Components.Navbar.view "Main title"
    , section [ class "section" ][
      div [ class "columns" ][
        div [ class "column is-two-thirds" ][
          Components.Hello.view model.amount Msgs.Increment
        ]
        , div [ class "column" ][
          Components.Sponsors.view model.sponsors
        ]
      ]
    ]
  ]
