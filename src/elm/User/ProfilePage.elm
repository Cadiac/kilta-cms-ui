module User.ProfilePage exposing (view)

import Msgs exposing (Msg)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import RemoteData exposing (WebData)

import Models exposing (LoginForm, Model, Profile)

maybeProfileForm : WebData Profile -> Html Msg
maybeProfileForm response =
  case response of
    RemoteData.NotAsked ->
      text ""

    RemoteData.Loading ->
      text "Loading..."

    RemoteData.Success profile ->
      Html.form
        [ onSubmit Msgs.UpdateProfile ] [
          div [] [
            div [ class "field" ]
              [ label
                [ class "label"
                , for "firstName" ]
                [ text "Etunimi" ]
              , input
                [ class "input"
                , onInput (Msgs.ProfileFormInput Models.FirstName)
                , value profile.firstName
                ]
                []
              ]
            , div
              [ class "field" ]
              [ label
                [ class "label"
                , for "lastName" ]
                [ text "Sukunimi" ]
              , input
                [ class "input"
                , onInput (Msgs.ProfileFormInput Models.LastName)
                , value profile.lastName
                ]
                []
              ]
            , div
              [ class "field" ]
              [ label
                [ class "label"
                , for "email" ]
                [ text "Sähköposti" ]
              , input
                [ class "input"
                , onInput (Msgs.ProfileFormInput Models.Email)
                , value profile.email
                ]
                []
              ]
            , div
              [ class "field" ]
              [ label
                [ class "label"
                , for "phone" ]
                [ text "Puhelin" ]
              , input
                [ class "input"
                , onInput (Msgs.ProfileFormInput Models.Phone)
                , value profile.phone
                ]
                []
              ]
            , div
              [ class "field" ]
              [ p
                [ class "control" ]
                [ button
                  [ class "button is-primary"
                  , type_ "submit" ]
                  [ text "Tallenna" ]
                ]
              ]
            ]
          ]

    RemoteData.Failure error ->
      text (toString error)

view : Model -> Html Msg
view model =
  div [ class "box" ] [
    div [ class "heading" ] [
      h1 [ class "title is-3" ] [
        text "Profiili"
      ]
    ]
    , maybeProfileForm model.profile
  ]
