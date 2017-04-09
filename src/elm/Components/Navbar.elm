module Components.Navbar exposing (view)

import Html exposing (..)
import Html.Attributes exposing (..)

view : String -> Html a
view title =
  header [ class "nav" ][
    div [ class "nav-left" ][
      div [ class "nav-item" ][
        text ( title )
      ]
    ]
    , div [ class "nav-right nav-menu" ][
      a [ class "button is-primary is-inverted" ][
        span [ class "icon" ][
          i [ class "fa fa-github" ][]
        ],
        span [][
          text ( "Login" )
        ]
      ]
    ]
  ]
