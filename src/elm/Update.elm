module Update exposing (..)

import Msgs exposing (Msg)
import Models exposing (Model, Profile)
import Navigation exposing (newUrl)
import Commands exposing (submitCredentials, saveToken, clearToken, setTitle, updateProfile)
import Decoders exposing (maybeDecodeToken)
import RemoteData exposing (WebData)

import Dict exposing (Dict)

import Routing exposing (parseLocation, fetchLocationData, locationTitle)

setProfileFirstName : String -> WebData Profile -> WebData Profile
setProfileFirstName newName profile =
  case profile of
    RemoteData.Success profile ->
      RemoteData.Success { profile | firstName = newName }

    RemoteData.NotAsked ->
      profile

    RemoteData.Loading ->
      profile

    RemoteData.Failure error ->
      profile

setProfileLastName : String -> WebData Profile -> WebData Profile
setProfileLastName newName profile =
  case profile of
    RemoteData.Success profile ->
      RemoteData.Success { profile | lastName = newName }

    RemoteData.NotAsked ->
      profile

    RemoteData.Loading ->
      profile

    RemoteData.Failure error ->
      profile

setProfileEmail : String -> WebData Profile -> WebData Profile
setProfileEmail newEmail profile =
  case profile of
    RemoteData.Success profile ->
      RemoteData.Success { profile | email = newEmail }

    RemoteData.NotAsked ->
      profile

    RemoteData.Loading ->
      profile

    RemoteData.Failure error ->
      profile

setProfilePhone : String -> WebData Profile -> WebData Profile
setProfilePhone newPhone profile =
  case profile of
    RemoteData.Success profile ->
      RemoteData.Success { profile | phone = newPhone }

    RemoteData.NotAsked ->
      profile

    RemoteData.Loading ->
      profile

    RemoteData.Failure error ->
      profile


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
  case msg of
    Msgs.NoOp -> (model, Cmd.none)

    Msgs.ChangeLocation path ->
      ( model, newUrl path )

    Msgs.OnLocationChange location ->
      let
        newRoute =
          parseLocation location
        newTitle =
          locationTitle (RemoteData.toMaybe model.info) newRoute
        commands =
          Cmd.batch
            [ fetchLocationData newRoute model
            , setTitle newTitle
            ]
      in
        ( { model | route = newRoute }, commands )

    Msgs.Login ->
      model !
        [ submitCredentials model
        , newUrl "/"
        ]

    Msgs.Logout ->
      { model | token = "", decodedToken = Nothing, logoutTimer = 5 } !
        [ clearToken ()
        , newUrl "/logout"
        ]

    Msgs.LogoutTimerTick newTime ->
      let
        newTimer =
          model.logoutTimer - 1
        command =
          if newTimer == 0 then
            newUrl "/"
          else
            Cmd.none
      in
        { model | logoutTimer = newTimer } ! [ command ]

    Msgs.Auth res ->
      case res of
        Result.Ok tokenString ->
          ( { model | token = tokenString, decodedToken = maybeDecodeToken tokenString }, saveToken tokenString )

        Result.Err err ->
          ( { model | token = "", decodedToken = Nothing, error = toString err }, Cmd.none )

    Msgs.LoginFormInput inputId val ->
      case inputId of
        Models.Username ->
          { model | username = val } ! []

        Models.Password ->
          { model | password = val } ! []

    Msgs.ProfileFormInput inputId val ->
      case inputId of
        Models.FirstName ->
          { model | profile = model.profile |> setProfileFirstName val } ! []
        Models.LastName ->
          { model | profile = model.profile |> setProfileLastName val } ! []
        Models.Email ->
          { model | profile = model.profile |> setProfileEmail val } ! []
        Models.Phone ->
          { model | profile = model.profile |> setProfilePhone val } ! []

    Msgs.UpdateProfile ->
      ( model, updateProfile model.config.apiUrl model.token (RemoteData.toMaybe model.profile) )

    Msgs.OnFetchSponsors response ->
      ( { model | sponsors = response }, Cmd.none )

    Msgs.OnFetchProfile response ->
      ( { model | profile = response }, Cmd.none )

    Msgs.OnFetchNewsList response ->

      ( { model | newsList = response }, Cmd.none )

    Msgs.OnFetchSingleNewsStory newsId response ->
      ( { model | news = Dict.insert newsId (response) model.news }, Cmd.none )

    Msgs.OnFetchEventsList response ->
      ( { model | eventsList = response }, Cmd.none )

    Msgs.OnFetchSingleEvent eventId response ->
      ( { model | events = Dict.insert eventId (response) model.events }, Cmd.none )

    Msgs.OnFetchInfo response ->
      ( { model | info = response }, Cmd.none )

    Msgs.OnFetchFooter response ->
      ( { model | footer = response }, Cmd.none )

    Msgs.OnFetchNewsCategories response ->
      ( { model | newsCategories = response }, Cmd.none )

    Msgs.OnFetchPageCategories response ->
      ( { model | pageCategories = response }, Cmd.none )

    Msgs.OnFetchSinglePage slug response ->
      ( { model | pages = Dict.insert slug (response) model.pages }, Cmd.none )
