module Arkham.Asset.Assets.HolyRosary (holyRosary) where

import Arkham.Asset.Cards qualified as Cards
import Arkham.Asset.Import.Lifted
import Arkham.Helpers.Modifiers

newtype HolyRosary = HolyRosary AssetAttrs
  deriving anyclass (IsAsset, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

holyRosary :: AssetCard HolyRosary
holyRosary = assetWith HolyRosary Cards.holyRosary (sanityL ?~ 2)

instance HasModifiersFor HolyRosary where
  getModifiersFor (HolyRosary a) = controllerGets a [SkillModifier #willpower 1]

instance RunMessage HolyRosary where
  runMessage msg (HolyRosary attrs) = HolyRosary <$> runMessage msg attrs
