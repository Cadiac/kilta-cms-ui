module Update exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model)

update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Msgs.NoOp -> (model, Cmd.none)

    Msgs.Increment -> ({ model | amount = model.amount + 1 }, Cmd.none)

    Msgs.FetchSponsors (Ok newSponsors) ->
      ({ model | sponsors = newSponsors }, Cmd.none)

    Msgs.FetchSponsors (Err _) -> (model, Cmd.none)

    Msgs.FetchInfo (Ok newInfo) ->
      ({ model | info = newInfo }, Cmd.none)

    Msgs.FetchInfo (Err _) -> (model, Cmd.none)
