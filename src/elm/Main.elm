module Main exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing ( onClick )

-- component import example
import Components.Hello exposing ( hello )


-- APP
main : Program Never Int Msg
main =
  Html.beginnerProgram { model = model, view = view, update = update }


-- MODEL
type alias Model = Int

model : number
model = 0


-- UPDATE
type Msg = NoOp | Increment

update : Msg -> Model -> Model
update msg model =
  case msg of
    NoOp -> model
    Increment -> model + 1


-- VIEW
-- Html is defined as: elem [ attribs ][ children ]
-- CSS can be applied via class names or inline style attrib
view : Model -> Html Msg
view model =
  div [ class "container" ][
    div [ class "box" ][    -- inline CSS (literal)
      article [ class "media" ][
        div [ class "media-left" ][
          figure [ class "image is-64x64" ][
            img [ src "static/img/elm.jpg"  ] []
          ]                             -- inline CSS (via var)
        ]
        , div [ class "media-content" ][
          div [ class "content" ][
            hello model                                                    -- ext 'hello' component (takes 'model' as arg)
            , p [ class "title is-4" ] [ text ( "Elm Webpack Starter" ) ]
            , button [ class "button is-primary", onClick Increment ] [                  -- click handler
              span [ class "icon is-small" ][
                i [ class "fa fa-star" ][]
              ]
              , span [][ text "Increment" ]
            ]
          ]
        ]
      ]
    ]
  ]


-- CSS STYLES
styles : { img : List ( String, String ) }
styles =
  {
    img =
      [ ( "width", "33%" )
      , ( "border", "4px solid #337AB7")
      ]
  }
