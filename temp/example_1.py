import os
os.environ['DEBUG'] = '5'
os.environ['GRAPH'] = '1'
# os.environ['GRAPHPATH'] = './tmp/graph'


from tinygrad import Tensor
from tinygrad.shape.shapetracker import ShapeTracker
from tinygrad.shape.view import View

t = Tensor(list(range(20)))
# b = Tensor(list(range(20)))

print("memory: \n", t.numpy())

a = t[2:2+9].reshape(3, 3).pad((None, (0, 2)))#.shrink((None, (0, 4)))
print("tensor: \n", a.numpy())

# b = Tensor(list(range(20)))
# print(b.numpy())

# a = Tensor.eye(3).realize()
assert not a.lazydata.is_unrealized_const()

print("a.lazydata.base: ", a.lazydata.base)
print()

print(f'{a.shape=}')
print(f'{a.lazydata.st.views=}')
idx, valid = a.lazydata.st.expr_idxs()
print(f'{idx=}')  # index -> buf location
print(f'{valid=}')  # mask
print()

s = ShapeTracker(views=(
    # idk random
    View.create(shape=(20,), strides=(1,), offset=0, mask=None),
    View.create(shape=(3, 5), strides=(3, 1), offset=2, mask=((0, 3), (0, 3))),
))
print(s)
print(s.simplify())

v = View.create(shape=(9,), strides=(1,), offset=0, mask=None)
print(v.reshape((3, 3)))