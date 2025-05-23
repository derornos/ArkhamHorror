module Arkham.Treachery.Cards.FrozenInFearAPhantomOfTruth (frozenInFearAPhantomOfTruth) where

import Arkham.Treachery.Cards qualified as Cards
import Arkham.Treachery.Cards.FrozenInFear
import Arkham.Treachery.Import.Lifted

newtype FrozenInFearAPhantomOfTruth = FrozenInFearAPhantomOfTruth FrozenInFear
  deriving anyclass IsTreachery
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity, HasModifiersFor, HasAbilities)

frozenInFearAPhantomOfTruth :: TreacheryCard FrozenInFearAPhantomOfTruth
frozenInFearAPhantomOfTruth =
  treachery (FrozenInFearAPhantomOfTruth . FrozenInFear) Cards.frozenInFearAPhantomOfTruth

instance RunMessage FrozenInFearAPhantomOfTruth where
  runMessage msg (FrozenInFearAPhantomOfTruth attrs) = FrozenInFearAPhantomOfTruth <$> runMessage msg attrs
