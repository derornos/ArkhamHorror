module Arkham.Asset.Assets.MagnifyingGlass (magnifyingGlass) where

import Arkham.Asset.Cards qualified as Cards
import Arkham.Asset.Import.Lifted
import Arkham.Helpers.Modifiers

newtype MagnifyingGlass = MagnifyingGlass AssetAttrs
  deriving anyclass (IsAsset, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

magnifyingGlass :: AssetCard MagnifyingGlass
magnifyingGlass = asset MagnifyingGlass Cards.magnifyingGlass

instance HasModifiersFor MagnifyingGlass where
  getModifiersFor (MagnifyingGlass a) = controllerGets a [ActionSkillModifier #investigate #intellect 1]

instance RunMessage MagnifyingGlass where
  runMessage msg (MagnifyingGlass attrs) = MagnifyingGlass <$> runMessage msg attrs
