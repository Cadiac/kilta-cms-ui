module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)

import Components.Navbar
import Components.Sponsors
import Components.News


view : Model -> Html Msg
view model =
  div [] [
    Components.Navbar.view "Main title"
    , section [ class "section" ] [
      div [ class "columns" ] [
        div [ class "column is-two-thirds"] [
          Components.News.view model.news
        ]
        , div [ class "column" ] [
          Components.Sponsors.view model.sponsors
        ]
      ]
    ]
  ]
