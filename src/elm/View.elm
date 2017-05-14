module View exposing (..)

import Html exposing (..)
import Html.Attributes exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model, Slug)

import Routing exposing (locationSubtitle, defaultCategoryPageSlug)

import Common.Navbar
import Common.Sponsors
import Common.Footer
import Common.GuildInfo
import Common.Jumbotron
import Common.Logo

import User.LoginForm
import User.ProfilePage
import User.LogoutPage

import News.NewsList
import News.NewsPage

import Events.EventsList
import Events.EventPage
import Events.EventWidget

import Pages.SubPage
import Pages.BoardPage

view : Model -> Html Msg
view model =
  div []
    [ Common.Logo.view model.info
    , Common.Navbar.view model
    , Common.Jumbotron.view model
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

    Models.LogoutRoute ->
      mainLayout model (User.LogoutPage.view model)

    Models.NewsListRoute ->
      mainLayout model (News.NewsList.view model.newsList)

    Models.NewsRoute id ->
      mainLayout model (News.NewsPage.view model id)

    Models.EventListRoute ->
      mainLayout model (Events.EventsList.view model.upcomingEvents)

    Models.EventRoute id ->
      mainLayout model (Events.EventPage.view model id)

    Models.PageRoute category ->
      mainLayout model (Pages.SubPage.view model (defaultCategoryPageSlug model category))

    Models.SubPageRoute category slug ->
      mainLayout model (Pages.SubPage.view model slug)

    Models.BoardRoute category year ->
      mainLayout model (Pages.BoardPage.view model year)

    Models.NotFoundRoute ->
      mainLayout model notFoundView

landingPage : Model -> Html Msg
landingPage model =
  div [] [
    Common.GuildInfo.view model.info,
    News.NewsList.view model.newsList,
    Events.EventsList.view model.upcomingEvents
  ]

mainLayout : Model -> Html Msg -> Html Msg
mainLayout model content =
  section [ class "section", style styles.mainSection ] [
    h1 [ class "title" ] [
      text (locationSubtitle model.route)
    ],
    div [ class "columns is-desktop" ] [
      div [ class "column is-9-desktop"] [
        content
      ]
      , div [ class "column" ] [
        Common.Sponsors.view model.sponsors,
        Events.EventWidget.upcomingView model,
        Events.EventWidget.pastView model
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
