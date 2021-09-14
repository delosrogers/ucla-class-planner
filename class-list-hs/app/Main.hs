module Main where

import qualified Data.HashSet as HashSet
import Lib
import Data.Aeson
import qualified Data.ByteString.Lazy as BS

main :: IO ()
main = do
  let courseRequirements = fmap decode BS.getContents :: IO (Maybe Requirements)
  fmap (fmap evaluateInput) courseRequirements >>= (\courses -> BS.putStr $ encode courses)


evaluateInput :: Requirements -> [Course]
evaluateInput reqs =
  possibleCourses (requiredCourses reqs) (HashSet.fromList $ coursesTaken reqs)
