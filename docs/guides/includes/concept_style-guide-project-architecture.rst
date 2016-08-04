Project Architecture
````````````````````

File Locations
~~~~~~~~~~~~~~

The Sphinx and RTD quick start guides both recommend creating a ``docs/`` directory in your project's repository. In addition, we recommend creating an ``includes`` sub-directory (``docs/includes``).

Place the following in the ``docs`` directory:

- :ref:`maps and mini-maps <document structure>`;
- the sphinx configuration file (conf.py);
- standalone documents that are not user guides but should be included in the build process.

Concept, topic, and reference files should be stored in the ``docs/includes`` sub-directory.

.. tip::

    Maps and mini-maps can reside in the same directory, but neither should live in the same directory as the source content files. In the `f5-openstack-docs`_ project repo, we've added an additional sub-directory, ``docs/guides/`` to separate the mini-maps from the maps for organizational purposes.

The example below shows the structure of this guide's parent repository, `f5-openstack-docs`_.

.. topic:: Example

    - ``docs/`` directory tree

    .. code-block:: text
        :emphasize-lines: 4,5,6,20

        docs/
        ├── Makefile
        ├── _static                                     \\ files to be excluded from the build (PDFs, downloadable files, etc.)
        ├── conf.py                                     \\ sphinx configuration file
        ├── guides                                      \\ optional subdirectory
        │   ├── includes                                \\ content for re-use
        │   │   ├── concept_clustering.rst
        │   │   ├── concept_ha-mirroring.rst
        │   │   ├── ref_deploy-guide-further-reading.rst
        │   │   ├── ref_deploy-guide-next-steps.rst
        │   │   ├── ref_os-config-guide-further-reading.rst
        │   │   ├── ref_os-config-guide-next-steps.rst
        │   │   ├── topic_assign-floating-ip.rst
        │   │   ├── topic_attach-subnet-to-router.rst
        │   │   ├── topic_configure-mgmt-network.rst
        │   │   ├── etc.
        │   ├── map_config-guide-intro.rst              \\ mini-map
        │   ├── map_deploy-ve-before-you-begin.rst      \\ mini-map
        │   ├── etc.
        ├── howto_deploy-ve-openstack.rst               \\ map
        ├── index.rst
        ├── make.bat
        ├── md-to-rst.sh
        ├── media                                       \\ image files used in documentation
        │   ├── example.png
        └── releases_and_versioning.rst                 \\ standalone document

    - screen shots of the GitHub repo:

    .. image:: ../media/f5osdocs_github-architecture.jpg
        :width: 550

    .. image:: ../media/f5osdocs_github-architecture-docs.jpg
        :width: 550


File Names
~~~~~~~~~~

Files intended for reuse should be named as follows:

==============  =======================================================
topics          ``topic_really-specific-description-of-content.rst``
concept         ``concept_really-specific-description-of-content.rst``
reference       ``ref_really-specific-description-of-content.rst``
==============  =======================================================

Include a description of the file's content that's as detailed as possible (within reason). This will help you and others identify what the content is without having to open and read the file.


Document Structure
~~~~~~~~~~~~~~~~~~

.. sidebar:: Key Takeaways:

    - Maps contain ``toctree`` lists of individual topics and/or mini-maps.
    - Mini-maps pull in topics via the ``includes`` function.
    - Maps can reside in the docs/ directory.
    - Mini-maps should reside in a docs/ sub-directory.
    - Topics should reside in a docs/ sub-directory (e.g., docs/includes).

:dfn:`Maps` are the means via which we can tie all of our content chunks together into cohesive documents. A map usually consists of a title, overview, and a ``toctree`` (see :ref:`Sphinx Syntax` for more information). The ``toctree`` resolves into a list of hyperlinks to the individual pages.

.. topic:: Example:

    The following map builds our :ref:`BIG-IP® VE Deployment Guide <How To Deploy BIG-IP VE in OpenStack>`.

    .. code-block:: text

        .. _deploy_big-ip_openstack:

        How To Deploy BIG-IP VE in OpenStack
        ====================================

        .. include:: guides/includes/concept_ve-deploy-guide-overview.rst
            :start-line: 5

        .. toctree::

            guides/map_deploy-ve-before-you-begin.rst
            guides/map_network-architecture
            guides/map_deploy-ve-initial-setup
            guides/map_network-setup
            guides/map_provider-network
            guides/map_launch-bigip-gui
            guides/map_deploy-guide-next-steps

The map shown in the above example consists of an ``include`` statement that pulls in a :ref:`concept <Topics, Concepts, and References>` and a ``toctree`` that lists a number of mini-maps.

:dfn:`Mini-maps` combine related topics into a section, or chapter, of a larger document. Mini-maps can either include content via the sphinx ``include`` function (see :ref:`Sphinx Syntax`) or via a ``toctree``. The ``include`` function pulls the content from the source topic into the minimap.


.. topic:: Example:

    The following mini-map combines many related concept docs into the 'Network Architecture' section of the VE Deployment Guide.

    .. code-block:: text

        Network Architecture
        --------------------

        .. include:: includes/concept_single-tenancy.rst

        .. include:: includes/concept_multi-tenancy.rst

        .. include:: includes/concept_vlans.rst

        .. include:: includes/concept_high-availability.rst

        Mirroring
        ~~~~~~~~~

        .. include:: includes/concept_ha-mirroring.rst
            :start-line: 5

        Clustering
        ~~~~~~~~~~

        .. include:: includes/concept_clustering.rst
            :start-line: 5

        .. include:: includes/concept_sr-iov.rst

