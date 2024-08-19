module Main where

import Data.Show (show)
import HTTPurple (class Generic, RouteDuplex', ServerM, mkRoute, ok, segment, serve, (/))
import Prelude (($), (<>))

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
  router { route: Hello name, headers } =
    ok $ "hello " <> name <> "\n" <> show headers
