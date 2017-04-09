module Components.Hello exposing (view)

import Msgs exposing (Msg)

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

import String

-- hello component
hello : Int -> Html a
hello model =
  div
    [ class "h1" ]
    [ text ( "Hello, Elm" ++ ( "!" |> String.repeat model ) ) ]

view : Int -> Msg -> Html Msg
view amount increment =
  div [ class "box" ][    -- inline CSS (literal)
    article [ class "media" ][
      div [ class "media-left" ][
        figure [ class "image is-64x64" ][
          img [ src "static/img/elm.jpg"  ] []
        ]                             -- inline CSS (via var)
      ]
      , div [ class "media-content" ][
        div [ class "content" ][
          hello amount                                                    -- ext 'hello' component (takes 'model' as arg)
          , p [ class "title is-4" ] [ text ( "Elm Webpack Starter" ) ]
          , button [ class "button is-primary", onClick increment ] [                  -- click handler
            span [ class "icon is-small" ][
              i [ class "fa fa-star" ][]
            ]
            , span [][ text "Increment" ]
          ]
        ]
      ]
    ]
  ]
