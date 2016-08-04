Sphinx Syntax
`````````````

There is a wealth of information regarding how to use rST and Sphinx available online; instead of duplicating that information here, we'll point you to our most-used resources.

  - `Sphinx reStructuredText Primer <http://www.sphinx-doc.org/en/stable/rest.html>`_
  - `Sphinx Markup Constructs <http://www.sphinx-doc.org/en/stable/markup/index.html>`_
  - `Sphinx Extensions`_

Commonly Used Sphinx Markup
~~~~~~~~~~~~~~~~~~~~~~~~~~~

#. To reuse a topic, concept, or reference by pulling the content in to a new document:

    .. code-block:: rST

        .. include:: includes/concept_sr-iov.rst

#. To create a table of contents:

    .. code-block:: rST

        .. toctree::
            :max-depth: 2
            :hidden:

            minimap_1
            minimap_2
            includes/topic_3



#. Other `paragraph-level markup`_ (examples included throughout this guide):

    * ``.. note::``              Inserts a "note" content block.
    * ``.. tip::``               Inserts a "tip" content block.
    * ``.. warning::``           Inserts a "warning" content block.
    * ``..important::``          Inserts an "important" content block.
    * ``.. seealso::``           Inserts a "See also" content block.
    * ``.. glossary::``          Identifies a list of glossary terms that can be cross-referenced.


#. `Cross-references`_

    * ``:ref:`xyz <>```          Use to insert a cross reference to a section, document, etc.

        Examples:

        * ``:ref:`Sphinx Syntax``` resolves to :ref:`Sphinx Syntax`.
        * ``:ref:`Network Architecture``` resolves to :ref:`Network Architecture`.
        * ``:ref:`VE deployment guide <How To Deploy BIG-IP VE in OpenStack>``` resolves to :ref:`VE deployment guide <How To Deploy BIG-IP VE in OpenStack>`
        * ``:ref:`Go to the LBaaSv2 Documentation <lbaasv2:home>``` resolves to :ref:`Go to the LBaaSv2 Documentation <lbaasv2:home>`.

    .. important::

        The examples given above use the following `Sphinx Extensions`_ for easy referencing within, and across, documentation sets.

        * ``sphinx.ext.autosectionlabel`` automatically turns all headers into section labels.
        * ``sphinx.ext.intersphinx`` allows you to reference other Sphinx documentation sets.

.. seealso::

    - `Sphinx inline markup documentation <http://docutils.sourceforge.net/docs/ref/rst/directives.html#including-an-external-document-fragment>`_
    - `Sphinx toctree documentation <http://www.sphinx-doc.org/en/stable/markup/toctree.html#directive-toctree>`_
