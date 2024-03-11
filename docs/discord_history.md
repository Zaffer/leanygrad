# bounties

geohot — 08/12/2023 20:22
new $1000 bounty: "Proof or disproof of the mergablity of two arbitrary ShapeTrackers in Lean (see docs/reshape_without_symbolic.md)"




# lean-tinygrad

ppg — 30/01/2024 14:14
It needs to send all equivalent shapetrackers to the same canonical shapetracker.  See examples here: https://github.com/tinygrad/tinygrad/pull/2940
GitHub
Fix 'FUZZ=plus PYTHONPATH="." python3 test/external/fuzz_shapetrack...#2940


mason — 30/01/2024 17:06
The only way shapetrackers can be different is if you didn't merge them when they could be merged
so it's canonical if everything is merged
if you do a = ShapeTracker.from_shape((10,10)) and then do a=a.permute((10,10)) then any reshape that can't be made from breaking up 10 and breaking up 10 will be a new view


chaosagent — 30/01/2024 17:22
views can be arbitarily messed up


mason — 30/01/2024 17:47
from what?  reshape operation? or like you define a list of views that could be invalid or unreachable
chaosagent — 30/01/2024 18:13
check out how convolutions are constructed
you can construct any (shape, strides, mask) with just the basic ops, i think theres even some code in tinygrad to do that 
then you have funny things where you can merge the complex strides to later or earlier views
or you can reorder the shape in the non-last views
without changing what the st actualyl does
also if you have small dims in later views, they can create situations where you can rewrite earlier views into something different


KamiKomplex504 — 30/01/2024 20:43
Any set of slices in any step and any direction without uniformity or regularity should be constructable as a virtually contiguous view of the underlying tensor. This property should also extend across any number of views. That would be ideal, I'll reread the bounty but what chaos said is correct. Also another nice property would be a reduction of any view to the optimal view where optimal is most likely the least disjointed step wise slices of contiguous memory but probably also with a single direction.
Disclaimer I have no bearing on the bounty, I am implementing something similar and that is basically what I'm trying to achieve there.


KamiKomplex504 — 30/01/2024 21:01
Ah I see it is for an equality test, so the viewing doesn't necessarily need to be improved. Ok so the optimization problem actually would be likely what leads to the solution, if you can deterministically reduce any arbitrary view to the unique optimal form then you would be able to test equality from there. That might end up a rabbit hole, not too trivial to perform. I would say take a flattened or unraveled view, then iterate through the slices and combine any contiguous regions. If a slice has a step not equal to a neighbor then you would donate (or steal depending on size I guess) the ends if that element is contiguous. I would also prune any empty slices as you could have any arbitrary arrangement of those. You could also ditch negative direction but at least don't try to combine more than one element with a negative step to a positive step. 


mason — 30/01/2024 23:45
Are the possible directions horizontal and vertical slices (like contiguous and permute) while also all linear combinations of rows and columns?
what's the formal definition of the slice of a tensor


KamiKomplex504 — 31/01/2024 07:41
Slices should be well defined, it's a native python class. They do have some quirks. I noticed in that repo ppg linked they are using an odd form of it but principles should be the same, a start, stop and step with negative index allowed and negative direction, and out of bounds behaviors.




# tinygrad-dev

mason — 01/01/2024 15:50
is shapetracker unique to tinygrad or are there papers about it
tobi — 01/01/2024 18:56
I believe I saw something similar in numpy


KamiKomplex504 — 01/01/2024 18:56
It is probably the term for the tinygrad implementation but in general shape tracking and memory views are a general concept. There are likely papers on them and I seem to remember a paging algorithm a classmate of mine wrote that could replace the current powers of 2 approaches in today's systems. Has a tangent idea to views. I would look at numpy for how it represents arrays and see if they use a decent view and shape algorithm.
Also memory heap algorithms are another kind of concept to learn about, you can poke around what bottle necks hardware needs to avoid (data movement mostly in this case but also wave compute saturation) and see what strategies people use to combat that.


mason — 01/01/2024 20:10
I mean is there papers on the actual abstract algebra of it? Like do Views/Shapes form a group or a monoid? Is there a paper that has that stuff so I don't have to waste time on that?
Image
why does this create two views even? Just because the matrix is permuted?
There's not clear causality to me right now (beacuse I want a paper) 
The number of items is clearly an invariant when it comes to reshaping. And You can only reshape shapes to other factorizations of prod(shape), with an arbitrary amount of 1s (because 1 is an identity)
But is this new? surely there's a math paper on this already that would save everybody time


ppg — 21/01/2024 00:50
Guys, I have a dumb idea for fixing/removing multiview shapetrackers and symbolic.  Just brute force check if the function from the outer view to the buffer is affine (it's a simple composition of linear functions defined by strides and the canonical (nonlinear) map from a buffer back to each view).   Affine just means it's given by an offset and strides, so the shapetracker can be reduced to a single view.  The brute force check shouldn't be too bad since it's just O(size(shape)) which at the worst fits in memory. 


chenyu — 21/01/2024 01:07
i can see some version of that working, you might only need to test corners too and check for twists. that's why we have bounties for canonical shapetracker and prove the view merging criteria!




# general

Dalian — 31/12/2023 06:59
I wanted to pick up on the question of @ppg, who asked in bounties about "Proof or disproof of the mergeability of two arbitrary ShapeTrackers in Lean (see docs/reshape_without_symbolic.md)" and never received an answer. 
While https://github.com/tinygrad/tinygrad/pull/2704 was opened, there were also questions asked in the PR that went unanswered.
So I still have not seen a sufficient explanation of the problem statement. (If there is one please just link me to it)

The bounty speaks of the merging of arbitrary ShapeTrackers - while the document talks about the reshaping of views.
In the document itself there is the idea of merging individual mergability - with a note that it will be discussed later - but this is either never done; or done in a way that escapes my current understanding of the problem domain.

Therefore I would like to ask for a more precise definition of the problem/the proof sought.

Are you looking for: 
an algorithm the can merge two arbitrary shape trackers if it is possible; and a proof that the algorithm works as intended.
a proof concerning the current implementation of merge_views in ShapeTracker.py?
a proof that the algorithm described in reshape_without_symbolic.md is correct?
something completely different?
 
GitHub
Lean for mergeability of views by PaulGustafson · Pull Request #2704...


chaosagent — 31/12/2023 10:20
The proof is likely to be an algorithm with proof of correctness, unless you have some theory I don't know about 👀
Most of the work is just going to be the lean though, the proof shouldn't be too hard I think


Dalian — 31/12/2023 17:29
@chaosagent
Thank you for the reply - I concur that the proof itself will mostlikely be the lesser issue.
But while I am confident about my abilities to translate a proof into lean; I am uncertain what exactly needs to be proven?

As I am new to tinygrad I am a bit flustered as the words shapetracker and view (and for some parts merge/reshape) are used seamingly interchangeable.

Could I bother you (or anyone for that reason) to restate the task?


chaosagent — 31/12/2023 21:51
Iirc the thing that prompted this was: for a shape tracker with more than one view, the symbolic code in expr_idxs is very expensive. So we want to get the views of multiview shapetrackers merged to make a single view shapetrackers when we can


Dalian — 01/01/2024 13:16
After looking through the code (especially merge_views/expr_idxs (shapetracker.py) and reshape (view.py)), I am still uncertain what it means for two views to be mergable/non-mergeable.

Pytorch has a formular (https://pytorch.org/docs/stable/generated/torch.Tensor.view.html) which determines when an additional view can't be constructed without copying values. Is this the underlying problem?
That a shapetracker has a set of views v1 and v2, that could be constructed from oneanother without copying values, and therefore one of them would suffice?
(Or more precisely a "merged view" from which both other views v1 and v2 could be constructed without copying)

Sorry for sounding a bit confused/slow; I am trying to wrap my head around some unfamiliar concepts - and while it is fun for me; I know it can be frustrating/annoying for others.


geohot — 01/01/2024 13:16
i updated the bounty and clarified here https://github.com/tinygrad/tinygrad/pull/2940


KamiKomplex504 — 01/01/2024 18:42
So the shape tracker needs to be able to define the view of a tensor with a shape outside of the data itself. This allows views without copy that are comparable. Then a flattening of the tensor is a canonical representation of any data which is how it is represented in memory. You can also define any shape not just 2d by defining exactly what an increase along a dimension like row or column means as a jump in continuous memory flattened memory. But they don't have to be complete views. You could define it with a starting and ending point within the array. Aka [[2,3], [4,5]] should be allowed to compare equal to [[1,2,3],[4,5,6]] since they are both a view of the underlying [1,2,3,4,5,6]. If you don't want it to be continuous and want faster flexible reshapes and moves or trims etc, you would probably want a set of partials in a linked list structure. That is how I understand the problem statement.


geohot — 06/01/2024 23:29
Also, size shouldn’t be in the shapetracker, it should be in the lazybuffer


acow — 14/02/2024 08:53
I tried to grugbrain the output of ShapeTracker.expr_idxs() back into one View. Also took the top level view.shape as an argument. just brute force sampled a ton of values in the inequalities to derive a valid range per dimension (instead of solving a system of inequalities with % and // involved, which seemed insane) and sampled values to derive strides and offset. I was kinda fuzz testing this. It didnt end up working in the more complicated cases, and I didnt even test it very well for simpler ones. Taking two shapetrackers and running them both thru this simplify often produced an equal result, I just wasnt checking for any information loss lol


TabularItem — 24/02/2024 17:28
@Dalian @James Wiles Did any of you get any closer on the bounty "Proof or disproof of the mergeability of two arbitrary ShapeTrackers in Lean (see docs/reshape_without_symbolic.md)"?
From past discussions here and on GitHub I have been trying to piece together the problem statement and the current progress on this.

From what I can tell, here is a possible problem statement:
Let a View be defined as a multidimensional array of elements with a mask (let's imagine that we know the definition of a mask).
Let a View v and a new shape new_shape of multidimensional array be given.
State and prove sufficient conditions for creating a new View w, such that
w has shape new_shape
the masks associated to v and w "select" the same set of elements
w and v flatten to the same 1d array

Now I am not sure of a few things:
Is the algorithm for this already implemented? How far along is the effort for this particular task that I have described above?
Is this the correct problem statement for the bounty?
Where do ShapeTrackers come into all this? I understand that a View is immutable, and that a ShapeTracker may contain multiple Views.

Edit: I have also realised that this operation probably also has to take into account the strides in each dimension. So even with a trivial mask, and assuming the product of the dimensions of the old shape matches that of the new shape, it may not be possible to perform the reshape operation if the original View is non-contiguous (also image that we know what this means). 


ppg — 24/02/2024 22:45
@TabularItem My understanding is that the bounty is asking for a proof that the function merge_views on two views is complete (i.e. merges any two mergeable views), or to make any required changes to merge_views to make it complete.     (It may also be asking for completeness for merging more than two views, but that is more complicated).  ShapeTrackers show up because merge_views acts on consecutive pairs of views in a shapetracker.    Multi-view shapetrackers come from sequences of ops containing reshapes.


TabularItem — 25/02/2024 05:04
One thing that's making this kind of hard is the lack of documentation/docstrings for these functions, so it seems that I have to reverse-engineer their purpose every time I encounter something new.
As a concrete example, with a name like un1d, I really have no idea what the output should be.
And the signature merge_views(vm2:View, vm1:View) -> Optional[View] kind of implies that the order of the input views doesn't matter, but reading just a few lines down, apparently it does. So I am not sure what is assumed of the input data, and what the properties of the output should be.


KamiKomplex504 — 25/02/2024 09:23
Your definition is a bit incomplete. What info does a shape tracker and view of an underlying data structure need? At a bare minimum you need the start and stop ranges. Slices add on stepping or stride. They also have direction (with sign) which I feel like could be mergeable if you wrap the array back into itself in circular fashion. For a proof you can assume that all the information you could want is available but I would look at the actual view class. You can also assume all the information is or can be well formated, what I mean is anything you would need can be implemented. I would say that reduced views are handy. The stop is exactly on the end of range, the step is 1 when it can be for single elements. Also empty views can be thrown out. With all that, the theory is going to drive what you need. Views have to be adjacent or overlapping to merge. But you can Make them have this. To make them adjacent if you can remove the elements in the gap with masks, any shapes can be adjacent. To make them overlap, the range has to be inclusive of elements of the other, the stop extends past the start of another but also the step has to align otherwise the next elements will not overlap. Every element to be merged has to be represented. That is not arbitrary and could quickly grow in complexity. But it compounds. You can merge a step of 1 with a step of 7 by masking the step 7 into a step 1. But if you then merge in another step 5 you need a new mask, you can't necessarily extend the current mask. A mask btw I am assuming to be the inverse of a selecting slice. The task is to come up with theory and rules like this and then prove them (apparently in lean which I'm ngl I have never heard of) but that is the challenge. Also once you have your theories the exceptions are the interesting bit, sure with unlimited compute and unlimited storage I might be able to represent any view, but what can I achieve with primitive representation?
Also it would be trivial to merge a set of views into an optimal reduced set. Worst case is the input is the output. But this is merging into a single view, if it is without modification to the view class then you need to see if everything is implemented for forced adjacency/overlap.


ppg — 25/02/2024 13:05
To understand the merge-views code, I would start with how multiview shape trackers get created with reshapes. It’s not really about merging arbitrary single views but composing consecutive views living inside a multiview shape tracker.


mason — 26/02/2024 14:16
in the ShapeTracker.simplify(), it takes the views and tries to merge them to the one immediately preceding it, and continues in that way where it's one directional


mason — 26/02/2024 15:42
Can anyone tell me if mergeable is both a 1-op and a 2-op because p1 is mergeable individually but also p1,p2 are mergeable?
```md
### Assumption
**p<sub>1</sub>** & **p<sub>2</sub>** individually are mergeable (we will discuss later on this) & we cannot merge **p<sub>1</sub>** & **p<sub>2</sub>**.
```
Is this correct : p1 mergeable, p2 mergeable, and (p1,p2) not mergeable
I think it's more like "the two subshapes are mergeable and old_shape is not mergeable


TabularItem — 26/02/2024 18:47
so I guess the goal is to somehow merge these multi-views such that they look the same to a consumer of the shapetracker api?
that is at least a good step towards defining the desired properties of a 'merge' operation, although it would be really nice to actually understand the purpose/function/desired behaviour of the View/ShapeTracker API instead of relying on unit tests to reverse engineer their desired behaviour


mason — 26/02/2024 18:54
I think the goal of the ShapeTracker API is to have an an algebraic system that can track the shape of the tensor as it goes through operations. Defining the shapetracker in the form of universal properties mean that compiled tensors and lazy tensors are guaranteed to act the same. The ShapeTracker must be able to track the shape of all valid operations and assert when an operation is invalid
sometimes (but it hasn't been formally proven), mutiple views are necessary to fully track the shape of a tensor (?). If this is true, checking whether two shapetrackers are equal would be linear in the length of views. If it was possible to merge list of views into a smaller list of views (maybe 1 view), then checking equality would be fast and easy

For example if you had a (10,10) shape with (1,10) strides and you permute it so the stides are (10,1) and you reshape the (10,10) shape to (100,) or (100,1), it would require two views to represent that this operation could have occurred I guess, but if you reshape the (100,)  back into (10,10) then you ony need one view because it's just a permute in total over the tensor
But also, ShapeTrackers tracking a shape over a convolution operation for example would reduce the total number of element in a tensor so ShapeTrackers need to also work for changing total number of elements
A view is the minimum amount of information required to transform a 1-D array of data into an arbitrary Tensor

The bounty statement is "Proof or disproof of the mergeability of two arbitrary ShapeTrackers in Lean (see docs/reshape_without_symbolic.md)" Which implies the solution must merge two ShapeTrackers (ie., a list of views, not a single view). Has anyone started to reason about the algebraic rules of merging two arbitrary lists of views?


ppg — 26/02/2024 22:27
Pretty sure that's a typo lol.  Should say views, not shapetrackers.  Look at docs/reshape_without_symbolic.md for a subcase
The idea is reshape makes multi-view shapetrackers, and we want to merge views inside a single shapetracker to reduce the number of views


ppg — 26/02/2024 22:38
Views are functions from 
`Fin_{n_1} \times Fin_{n_2} \times ... \times Fin_{n_k} -> Nat`
  given by strides + offset. There is also a map from 
`Fin_{n_1 \cdot n_k} \to Fin_{n_1} \times Fin_{n_2} \times ... \times Fin_{n_k}`
 given by inverting the default stride map.  A multiview shapetracker composes a bunch of these maps implicitly to get a map from the first view space to Nat (here Nat corresponds to memory buffer addresses).


mason — 26/02/2024 22:38
so there could be the case that a shapetracker is a list of disjoint views than can be syntheized into one view correct?


ppg — 26/02/2024 22:39
No, they are not disjoint. You think of them as functions to compose (coming from reshapes interspersed with other ops) 


mason — 26/02/2024 23:24
why did you use Fin? is this Fin type from lean 4? 


mason — Yesterday at 01:46
I'm sorry I don't think views are functions defined like you said because views are defined as a list of shapes and strides and offset and mask
so a multiview shapetracker is not composing those exact functions
I can't even compose these functions
Views are functions from 
`Fin{n_1} \times Fin{n2} \times ... \times Fin{n_k} -> Nat`
  given by strides + offset. There is also a map from 
I think this is the index of a view


Karl — Yesterday at 05:21
I think what he meant is that a view is a functor which is a high order function.


mason — Yesterday at 11:22
But the View function doesn't take k-tuples and output a memory address. It takes a shape at the very least and outputs a structure of the union of four lists


KamiKomplex504 — Yesterday at 16:45
Define disjoint, if I have indexes in view( [0-2] , [2-5] ) the view can be reduced to view ( [0-5]) but also if I have view( [2,4] , [6,8] ) well that is two adjacent views with stride/step 2 they can also be merged. Also a tensor can have multiple shape trackers, so shape trackers which may have multiple views could also be mergeable. But I do think the problem was focused around merging views not really shape trackers.


mason — Today at 02:55
Does anyone have a a bunch of tests for merge_views
there's probally not a test for all cases of View 
I think @corsix you have some?


mason — Today at 03:08
and does real_strides see if it's possible to use the same strides for every single view or what
I don't wnat to use real_strides but can anyone explain what it's functionally doing in the codebase in the first place
I wish ShapeTracker was actually good so bad


corsix — Today at 03:30
I have not written any; just exercised existing tests with various options.


mason — Today at 03:30
I don't think 'merge_views' is called in any program in test/


flammit — Today at 03:48
that would be incredibly simple to prove no?


mason — Today at 03:48
did i use grep wrong


flammit — Today at 03:50
is simplify used anywhere in a test? or maybe throw an error at the top and see how many tests it breaks
