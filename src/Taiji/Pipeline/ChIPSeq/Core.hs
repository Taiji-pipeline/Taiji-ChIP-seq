{-# LANGUAGE FlexibleContexts  #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell   #-}

module Taiji.Pipeline.ChIPSeq.Core (builder) where

import           Control.Lens
import           Scientific.Workflow

import           Taiji.Pipeline.ChIPSeq.Config
import           Taiji.Pipeline.ChIPSeq.Core.Functions

builder :: Builder ()
builder = do
    node' "Get_Peak" 'chipGetPeak $ submitToRemote .= Just False
