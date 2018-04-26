{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Taiji.Pipeline.ChIPSeq.Core (builder) where

import           Bio.Data.Experiment
import           Bio.Data.Experiment.Parser
import           Bio.Pipeline.NGS
import           Bio.Pipeline.Utils
import           Control.Lens
import           Control.Monad.IO.Class                (liftIO)
import           Control.Monad.Reader                  (asks)
import           Data.Bitraversable                    (bitraverse)
import           Data.Either                           (either)
import           Data.Maybe                            (fromJust)
import           Data.Monoid                           ((<>))
import           Scientific.Workflow

import           Taiji.Pipeline.ChIPSeq.Config
import           Taiji.Pipeline.ChIPSeq.Core.Functions

builder :: Builder ()
builder = do
    node' "Get_Peak" 'chipGetPeak $ submitToRemote .= Just False
