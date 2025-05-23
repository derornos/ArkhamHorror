module Arkham.Treachery.Cards.LiberOmniumFinium (liberOmniumFinium) where

import Arkham.Card
import Arkham.Investigator.Types (Field (..))
import Arkham.Keyword (Keyword (Peril))
import Arkham.Matcher
import Arkham.Modifier
import Arkham.Projection
import Arkham.Treachery.Cards qualified as Cards
import Arkham.Treachery.Import.Lifted

newtype LiberOmniumFinium = LiberOmniumFinium TreacheryAttrs
  deriving anyclass (IsTreachery, HasModifiersFor, HasAbilities)
  deriving newtype (Show, Eq, ToJSON, FromJSON, Entity)

liberOmniumFinium :: TreacheryCard LiberOmniumFinium
liberOmniumFinium = treachery LiberOmniumFinium Cards.liberOmniumFinium

instance RunMessage LiberOmniumFinium where
  runMessage msg t@(LiberOmniumFinium attrs) = runQueueT $ case msg of
    Revelation iid (isSource attrs -> True) -> do
      cardsUnderneath <-
        onlyEncounterCards . filterCards NonWeakness <$> field InvestigatorCardsUnderneath iid

      case cardsUnderneath of
        (x : xs) -> do
          c <- sample (x :| xs)
          cardResolutionModifiers c attrs (toCardId c) [AddKeyword Peril, EffectsCannotBeCanceled]
          cardResolutionModifier c attrs iid (AnySkillValue (-2))
          drawCard iid c
        _ -> shuffleIntoDeck iid attrs

      pure t
    _ -> LiberOmniumFinium <$> liftRunMessage msg attrs
