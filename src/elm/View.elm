module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)

import Components.Navbar
import Components.Sponsors
import News.List
import News.NewsStory

view : Model -> Html Msg
view model =
  div []
    [ Components.Navbar.view model.info
    , page model
    ]

page : Model -> Html Msg
page model =
  case model.route of
    Models.IndexRoute ->
      landingPage model

    Models.NewsListRoute ->
      News.List.view model.newsList

    Models.NewsRoute id ->
      News.NewsStory.view model id

    Models.NotFoundRoute ->
      notFoundView

landingPage : Model -> Html Msg
landingPage model =
  section [ class "section" ] [
    div [ class "columns" ] [
      div [ class "column is-two-thirds"] [
        News.List.view model.newsList
      ]
      , div [ class "column" ] [
        Components.Sponsors.view model.sponsors
      ]
    ]
  ]

notFoundView : Html msg
notFoundView =
  section [ class "section" ] [
    text "Not found"
  ]
