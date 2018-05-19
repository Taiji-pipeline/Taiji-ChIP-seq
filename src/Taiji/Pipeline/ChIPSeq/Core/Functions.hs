{-# LANGUAGE DataKinds             #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE GADTs                 #-}
{-# LANGUAGE OverloadedStrings     #-}
{-# LANGUAGE PartialTypeSignatures #-}
{-# LANGUAGE TemplateHaskell       #-}
module Taiji.Pipeline.ChIPSeq.Core.Functions
    ( chipGetPeak
    ) where

import           Bio.Data.Experiment
import           Bio.Pipeline.NGS.Utils
import           Bio.Pipeline.Utils
import           Control.Lens
import           Data.Either                   (lefts)
import           Data.Maybe                    (mapMaybe)
import           Scientific.Workflow

import           Taiji.Pipeline.ChIPSeq.Config

type ChIPSeqWithSomeFile = ChIPSeq N [Either SomeFile (SomeFile, SomeFile)]

type ChIPSeqMaybePair tag1 tag2 filetype =
    Either (ChIPSeq S (File tag1 filetype))
           (ChIPSeq S (File tag2 filetype, File tag2 filetype))

type ChIPSeqEitherTag tag1 tag2 filetype = Either (ChIPSeq S (File tag1 filetype))
                                                  (ChIPSeq S (File tag2 filetype))

chipGetPeak :: [ChIPSeqWithSomeFile]
            -> [ ChIPSeq S (Either (File '[] 'NarrowPeak)
                                   (File '[] 'BroadPeak)) ]
chipGetPeak inputs = concatMap split $ concatMap split $
    inputs & mapped.replicates.mapped.files %~ f
  where
    f fls = flip mapMaybe (lefts fls) $ \fl ->
        case getFileType fl of
            NarrowPeak -> Just $ Left $ fromSomeFile fl
            BroadPeak  -> Just $ Right $ fromSomeFile fl
            _          -> Nothing
