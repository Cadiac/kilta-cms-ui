module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)

import Components.Navbar
import Components.Sponsors
import News.List


view : Model -> Html Msg
view model =
  div [] [
    Components.Navbar.view model.info
    , section [ class "section" ] [
      div [ class "columns" ] [
        div [ class "column is-two-thirds"] [
          News.List.view model.news.list
        ]
        , div [ class "column" ] [
          Components.Sponsors.view model.sponsors
        ]
      ]
    ]
  ]
