

hadMod8 - git commit:
*******
Added discards to the previous model.

hadMod7 - git commit:
*******
Same as hadMod6, but parameters for both selectivity (survey and commercial fleets) as well as growth are fixed to known.

hadMod6 - git commit:
*******
Switched the lenght group distribution in the survey sampling to shorter length groups - every 2 cm. Biomass is still off; this model does not seem any different, which I kind of expected.

hadMod5 - git commit:
*******
I was concerned that the sampling procedure in mfdbatlantis and the error on lengths was causing some issues with the model, so for survey indices and lengths I simply took a small proportion directly from the total instead of distributing errors on fish lengths.

noAgeModel - 
**********
This is hadMod3 with age data completely removed.

hadMod4 - git commit:
*******
Same as hadMod3 but running with known selectivity curves. This didn't seem to help any. In fact I think the model with the incorrectly estimated selectivity curves looks better at least at first glance. I'll have to look at them closer to know for sure, though.

hadMod3 - git commit:
*******
I am using the actual known length weight relationship alpha and beta parameters to see if this changes the biomass estimates. This doesn't seem to have changed much at first, but I'm hoping that running this with the known selectivity curves will fix everything.

hadMod2 - git commit:
*******
I just changed the selectivity curves to what is used in Atlantis for this model. This looks really good now; the actual numbers between gadget and atlantis are very similar. Biomass is still too high for gadget, though.

hadMod1 - git commit:
*******
Initial version of a haddock model to compare gadget to atlantis. This really looked pretty good; it matched the trends really well, but the magnitude of biomass is off. I'm starting to wonder if it doesn't have something to do with the refweight file. Parameters for the length-weight relationship are really off when I pull it from the data (compared to what is used in the Atlantis model).
