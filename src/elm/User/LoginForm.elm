module User.LoginForm exposing (view)

import Msgs exposing (Msg)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

import Models exposing (LoginForm, Model)

view : Model -> Html Msg
view model =
  div [ class "box" ] [
    div [ class "heading" ] [
      h1 [ class "title is-3" ] [
        text "Kirjaudu sisään"
      ]
    ]
    , div []
      [ Html.form
        [ onSubmit Msgs.Login ]
        [ div []
          [ div [ class "field" ]
            [ label
              [ class "label"
              , for "username" ]
              [ text "Tunnus" ]
            , input
              [ class "input"
              , onInput (Msgs.LoginFormInput Models.Username)
              , value model.username
              ]
              []
            ]
          , div
              [ class "field" ]
              [ label
                [ class "label"
                , for "password" ]
                [ text "Salasana" ]
              , input
                [ class "input"
                , type_ "password"
                , onInput (Msgs.LoginFormInput Models.Password)
                , value model.password
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
                [ text "Kirjaudu" ]
              ]
            ]
          ]
        ]
      ]
    , div []
      [ p []
        [ text model.token ]
      ]
    ]
