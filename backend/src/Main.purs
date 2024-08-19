module Main where

import Data.Show (show)
import Effect.Class.Console as Console
import HTTPurple (class Generic, RouteDuplex', ServerM, mkRoute, ok, segment, serve, (/))
import Prelude (($), (<>), discard)

data Route = Hello String

derive instance Generic Route _

route :: RouteDuplex' Route
route = mkRoute
  { "Hello": "hello" / segment
  }

main :: ServerM
main =
  serve { port: 8080 } { route, router }
  where
  router { route: Hello name, headers } = do
    Console.log $ show headers
    ok $ "hello " <> name
