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
  a [ class "button is-primary is-inverted"
    , href "/login"
    , onLinkClick (Msgs.ChangeLocation "/login")
    ] [
    span [ class "icon" ][
      i [ class "fa fa-github" ] []
    ],
    span [] [
      text ( "Login" )
    ]
  ]

logoutButton : Html Msg
logoutButton =
  a [ class "button is-primary is-inverted"
    , onClick (Msgs.Logout)
    ] [
    span [ class "icon" ][
      i [ class "fa fa-sign-out" ] []
    ]
  ]

profileButton : String -> Html Msg
profileButton username =
 a [ class "button is-primary is-inverted"
     , href "/profile"
     , onLinkClick (Msgs.ChangeLocation "/profile")
     ] [
     span [ class "icon" ][
       i [ class "fa fa-github" ] []
     ],
     span [] [
       text ( username )
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
          div [] [
            profileButton decoded.username,
            logoutButton
          ]
        Nothing ->
          loginButton
    ]
  ]
