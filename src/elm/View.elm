module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)

import Routing exposing (locationSubtitle)

import Common.Navbar
import Common.Sponsors
import Common.Footer

import User.LoginForm
import User.ProfilePage

import News.NewsList
import News.NewsPage
import Events.EventsList
import Events.EventPage
import Pages.SubPage
import Pages.PagesMenu

view : Model -> Html Msg
view model =
  div []
    [ Common.Navbar.view model
    , page model
    , Common.Footer.view model
    ]

page : Model -> Html Msg
page model =
  case model.route of
    Models.IndexRoute ->
      mainLayout model (landingPage model)

    Models.LoginRoute ->
      mainLayout model (User.LoginForm.view model)

    Models.ProfileRoute ->
      mainLayout model (User.ProfilePage.view model)

    Models.NewsListRoute ->
      mainLayout model (News.NewsList.view model.newsList)

    Models.NewsRoute id ->
      mainLayout model (News.NewsPage.view model id)

    Models.EventListRoute ->
      mainLayout model (Events.EventsList.view model.eventsList)

    Models.EventRoute id ->
      mainLayout model (Events.EventPage.view model id)

    Models.PageRoute category ->
      mainLayout model (Pages.PagesMenu.view model)

    Models.SubPageRoute category slug ->
      mainLayout model (Pages.SubPage.view model slug)

    Models.NotFoundRoute ->
      mainLayout model notFoundView

landingPage : Model -> Html Msg
landingPage model =
  div [] [
    News.NewsList.view model.newsList,
    Events.EventsList.view model.eventsList
  ]

mainLayout : Model -> Html Msg -> Html Msg
mainLayout model content =
  section [ class "section", style styles.mainSection ] [
    h1 [ class "title" ] [
      text (locationSubtitle model.route)
    ],
    div [ class "columns" ] [
      div [ class "column is-9"] [
        content
      ]
      , div [ class "column" ] [
        Common.Sponsors.view model.sponsors
      ]
    ]
  ]

notFoundView : Html msg
notFoundView =
  section [ class "section", style styles.mainSection ] [
    text "Not found"
  ]


-- CSS STYLES

styles : { mainSection : List ( String, String ) }
styles =
  {
    mainSection =
      [ ( "min-height", "640px" ) ]
  }
