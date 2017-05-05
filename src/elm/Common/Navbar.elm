module Common.Navbar exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)

import Msgs exposing (Msg)
import Models exposing (Info, Model, PageCategory, NewsCategory)
import RemoteData exposing (WebData)

import Routing exposing (onLinkClick, pagePath, subPagePath)

navItem : String -> String -> Html Msg
navItem url title =
  div [ class "nav-item" ] [
    a [ href url, onLinkClick (Msgs.ChangeLocation url)] [
      h1 [ class "heading" ] [
        text title
      ]
    ]
  ]

maybeTitle : WebData (Info) -> Html Msg
maybeTitle info =
  case info of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      navItem "/" "Loading..."

    RemoteData.Success info ->
      navItem "/" info.title

    RemoteData.Failure error ->
      text (toString error)

pageItem : PageCategory -> Html Msg
pageItem page =
  navItem (pagePath page.slug) page.title

maybePageCategories : WebData (List PageCategory) -> Html Msg
maybePageCategories pages =
  case pages of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      navItem "/" "Loading..."

    RemoteData.Success pages ->
      div [ class "level" ] (
        List.map pageItem pages
      )

    RemoteData.Failure error ->
      text (toString error)

loginButton : Html Msg
loginButton =
  div [ class "nav-item" ] [
    div [ class "level" ] [
      a [ href "/login", onLinkClick (Msgs.ChangeLocation "/login")] [
        span [ class "icon" ][
          i [ class "fa fa-sign-in" ] []
        ],
        h1 [ class "heading" ] [
          text "Kirjaudu"
        ]
      ]
    ]
  ]

logoutButton : Html Msg
logoutButton =
  div [ class "nav-item" ] [
    a [ onClick (Msgs.Logout) ] [
      span [ class "icon" ][
        i [ class "fa fa-sign-out" ] []
      ]
    ]
  ]

profileButton : String -> Html Msg
profileButton username =
  div [ class "nav-item" ] [
    a [ class "level-left", href "/profile", onLinkClick (Msgs.ChangeLocation "/profile")] [
      h1 [ class "heading level-item" ] [
        text username
      ]
    ]
  ]

view : Model -> Html Msg
view model =
  header [ class "nav" ] [
    div [ class "nav-left" ] [
      maybeTitle model.info,
      maybePageCategories model.pageCategories
    ]
    , div [ class "nav-right nav-menu" ] [
      case model.decodedToken of
        Just decoded ->
          div [ class "level" ] [
            profileButton decoded.username,
            logoutButton
          ]
        Nothing ->
          loginButton
    ]
  ]
