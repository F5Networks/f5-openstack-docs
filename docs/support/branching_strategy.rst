F5 Development Branching Strategy
=================================

.. important:: Development for all F5® OpenStack projects in GitHub follows this branching strategy.

Key Points
----------

* Development takes place on **feature branches**, which tend to follow the naming convention *feature.<featurename>*. These branches are either created from **master** or from the branch that corresponds to the earliest OpenStack version to which the bugfix/change applies (e.g., ``liberty``).
* Feature branches are periodically merged into their 'parent' branches, most often in preparation for a release.
* Branches which correspond to specific OpenStack versions (e.g., ``kilo``, ``liberty``, ``mitaka``) are periodically merged up the chain to ensure commits which apply to multiple versions make it into each version's branch.
* ``master`` is the branch on which all development for new OpenStack versions occurs.

Development Example
```````````````````

#. Create ``feature.newton`` from ``master``.
#. All development to support the Newton release takes place on the ``feature.newton`` branch.
#. Merge the ``feature.newton`` branch into ``master`` when development for the release is complete.
#. Create the ``newton`` branch from ``master``.

   - All Newton version releases (e.g., 10.0.1, 10.0.2, etc.) come from the ``newton`` branch.
   - All bugfixes for Newton and later versions happen on feature branches created from, and then merged back into, the ``newton`` branch.

#. ``master`` then moves 'ahead' of ``newton`` in the branching structure; it is now the basis for all development for the Ocata release.

Bugfix Example
``````````````

#. Create a bugfix feature branch from ``liberty`` -- for example, ``bugfix#.liberty`` -- because that's the earliest OpenStack version in which the bug occurred.
#. Merge the ``bugfix#.liberty`` branch into ``liberty`` when development is complete.
#. Merge ``liberty`` up to ``mitaka``.
#. Merge ``mitaka`` up to ``newton``.
#. Merge ``newton`` up to ``master``.
#. The bugfix is then automatically included in ``ocata``, which the development team will create from ``master``.

.. figure:: /_static/media/branching_strategy.png
   :scale: 60%

   Branching Strategy
