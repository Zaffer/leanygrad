Zaffer — Yesterday at 14:57
@chenyu I am picking up the merge proof work again, and I want to make sure I am understanding the problem statement correctly and that the proof captures the intention.

Zaffer — Yesterday at 15:05
from what I looked at before it might be trivially possible with mask
or near impossible because it requires calculating the least prime factor to be equal 
unless I am miss-understanding something, as you suggested previously...

chenyu — Yesterday at 16:08
you can start with formalizing the reshape case, there are codes already. i don't understand your comment about trivially possible or nearly impossible (like undecidable?)

Zaffer — Yesterday at 16:12
yeah, undecidable, (maybe). We are working on it now

ppg — Yesterday at 22:43
@Zaffer  I think it's just asking to prove that merge_views is complete (i.e. prove that given an arbitrary shapetracker s,  then merge_views will return a single-view shapetracker if and only if s is mergeable).  So we have to prove that it reduces everything it should, and it doesn't miss anything.   Last I checked it wasn't actually complete -- you can generate multiview shapetrackers with a fuzzer that are mergeable but merge_views doesn't reduce.  So I think the next step for the bounty would be to try to fix merge_views to catch these cases 

Zaffer — Today at 11:28
thanks, we spent several hours on this on the clubhouse yesterday. I get the main idea, just want to check if my rephrasing it here is accurate:

Given a two Views, each with properties Shape, Stride, Offset, and Mask:
you want a proof that a certain set of checks on those properties will determine a valid merge.
OR 
do you want to proof that given a third view, you are able to check that it is a valid merge of the first two?
 
ppg — Today at 11:30
No, it's not really about abstract views.  It's about multiview shapetrackers which show up when you have a single view, and then you do a reshape which stacks the second view on top of that.
It's not a commutative operation, it's a composition with some stuff in between.
Zaffer — Today at 11:34
I'm starting to get the idea. So want the original view and the reshaped view to be flattened back into one view.

ppg — Today at 11:34
Yeah exactly

Zaffer — Today at 11:34
So this implies, the same underlying elements as a given.

ppg — Today at 11:35
Yeah, basically you can't have weird gaps in the memory layout
It's all the same elements. A view just specifies a memory layout and a multiview shapetracker can specify some weird layouts 

Zaffer — Today at 11:37
My question then is still about whether the proof must prove that a set of checks will determine any possible merge, or that there is a proof that the merged view is valid given the original and reshaped views... 

ppg — Today at 11:37
I think it's both but I'm not in charge of hte bouties lol
bounties*

Zaffer — Today at 11:40
It could be that validity it determined by just checking every element is contained exactly once in all multi-views and the the merged view, with no new elements added. Is there anything else that determines validity?
ppg — Today at 11:41
Here's a formal spec of the problem I wrote up a while ago.  It's in math language so lmk if anything doesn't make sense
Image
High level -- a shapetracker is a map from an index set to memory (represented as the natural numbers).  Only some of these maps can be represented as single views (those of the form "offset + \sum index_i * stride_i).

chenyu — Today at 11:46
don't know what you mean by validity, but we can check if two shapetrackers are equivalent by enumerating the index to mem location mapping. it's slow though
and that's partly why i'd be surprised if merging view is undecidable

ppg — Today at 11:48
The only idea I had was trying to find a good reduction algorithm for some subset of symbolic
I guess another thought would be to show that the shapetrackers we fail to merge are not very important

Zaffer — Today at 11:49
I thought we are merging the views inside of one shapetracker?

chenyu — Today at 11:50
you can enumerate potential merged shapetracker then verify if it's correct
claiming that it's undecidable means you cannot enumerate all possible merged shapetracker, which seems... not unlikely but would be weird
i think probably a better canonical view, then induction on dims

Zaffer — Today at 11:51
verification of correctness is what I mean by validity. so you are saying checking correctness is easy, you don't need a proof for that.

ppg — Today at 11:51
It's  decidable since you can just enumerate all maps from the index set to [0, max memory position]

chenyu — Today at 11:52
it really is written in the code already (multiple times!)
if you want to attempt to solve the problem, at least read what we have already?

Zaffer — Today at 11:54
you mean read the code. right, I was attempting to go off the original document and just understanding the concepts.
will read the code for the next session 🫡
