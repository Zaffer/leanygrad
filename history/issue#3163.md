Move merge_views into view.py #3163
Open
geohot opened this issue on Jan 17 · 1 comment
Comments
@geohot
Collaborator
geohot commented on Jan 17 • 
It shouldn't use a ShapeTracker and real_strides, it should use the same logic as View.reshape, but capable of merging two arbitrary Views

It should also be View.__add__ if that's okay to return an Optional

