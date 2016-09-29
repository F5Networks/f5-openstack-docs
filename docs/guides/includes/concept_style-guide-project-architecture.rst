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

    The following map builds our :ref:`LBaaSv2 User Guide <lbaasv2:user guide>`.

    .. code-block:: text

        F5 OpenStack LBaaSv2 User Guide
        ###############################

        This guide provides instructions for installing and using the F5® OpenStack LBaaSv2 service provider driver and agent (also called, collectively, 'F5 LBaaSv2').

        .. include:: includes/ref_lbaasv2-version-compatibility.rst
            :start-line: 5

        .. toctree::
            :maxdepth: 2

            map_before-you-begin
            map_configure-f5-agent
            includes/topic_configure-neutron-lbaasv2
            map_deployments

The map shown in the above example consists of an ``include`` statement that pulls in a :ref:`ref <Topics, Concepts, and References>` and a ``toctree`` that lists a number of mini-maps. The introduction statement can be hard-coded in the map or, if it is expected that it may need to be reused elsewhere, it can be a separate 'concept' file.

:dfn:`Mini-maps` combine related topics into a section, or chapter, of a larger document. Mini-maps can either include content via the sphinx ``include`` function (see :ref:`Sphinx Syntax`) or via a ``toctree``. The ``include`` function pulls the content from the source topic into the minimap.


.. topic:: Examples:

    The following mini-map combines the feature topics into the :ref:`Supported Features <lbaasv2:supported features>` section of :ref:`Configure the F5 OpenStack Agent <lbaasv2:Configure the F5 OpenStack Agent>`.

    .. code-block:: text

        Supported Features
        ------------------

        .. include:: includes/concept_supported-features-intro.rst
            :start-line: 2

        .. toctree::
            :maxdepth: 1

            includes/topic_device-driver-settings
            includes/topic_l2-l3-segmentation-modes
            includes/topic_global-routed-mode
            High Availability <includes/topic_ha-modes>
            Device Clusters <includes/topic_clustering>
            Multi-Tenancy <includes/topic_multi-tenancy>
            includes/topic_global-routed-mode
            includes/topic_cert-manager
            includes/topic_hierarchical-port-binding
            includes/topic_agent-redundancy-scaleout
            includes/topic_differentiated-services


The mini-map below combines the Supported Features map and related topics into the :ref:`Configure the F5 OpenStack Agent <lbaasv2:Configure the F5 OpenStack Agent>`. This is an example of a minimap that imports content from the source files, as opposed to simply including references to the content as done in the two preceding examples.

    .. code-block:: text

        .. _configure-the-f5-openstack-agent:

        Configure the F5 OpenStack Agent
        ================================

        .. include:: map_lbaasv2-features.rst

        .. include:: includes/topic_config-agent-overview.rst
            :start-line: 2

        Start the F5 agent
        ------------------

        .. include:: includes/topic_start-f5-agent.rst
            :start-line: 7

        Stop the F5 agent
        -----------------

        .. include:: includes/topic_stop-f5-agent.rst
            :start-line: 5


        .. include:: includes/ref_see-also.rst
            :start-line: 5


.. tip::

    Generally speaking, maps that create the **top-level** structure for a user guide use the ``toctree`` format. Mini-maps that comprise sections of a larger guide use the ``includes`` function to pull the content in from the source files.

