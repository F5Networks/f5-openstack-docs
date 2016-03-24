.. _add-projects-and-users-to-openstack:

Add Projects and Users
----------------------

.. note::

    - According to the `OpenStack documentation <http://docs.openstack.org/openstack-ops/content/projects_users.html>`_: "In OpenStack user interfaces and documentation, a group of users is referred to as a project or tenant. These terms are interchangeable."

    - You do not need to be logged in as root to run the below commands. You do need to source :file:`keystonerc_admin`, though.

.. _adding-projects:

Adding Projects
```````````````

As shown below, you can use the command ``openstack project create`` to create a new project (or tenant).

.. topic:: Example: Create a new project called 'demo1' with the description 'My demo project'.

    .. code-block:: shell

        $ openstack project create --description "My demo project" demo1
        +-------------+----------------------------------+
        | Field       | Value                            |
        +-------------+----------------------------------+
        | description | My demo project                  |
        | enabled     | True                             |
        | id          | fb76f73484554d3593964f24ec57bd05 |
        | name        | demo1                            |
        +-------------+----------------------------------+


.. _adding-users:

Adding Users
````````````

As shown below, you can use the command ``openstack user create`` to create a new user.

.. topic:: Example: Create a demo user with access to the 'demo1' project.

    .. code-block:: shell

        $ openstack user create --project demo1 --password foobar1 --email demo123@f5.com demo
        +------------+----------------------------------+
        | Field      | Value                            |
        +------------+----------------------------------+
        | email      | demo123@f5.com                   |
        | enabled    | True                             |
        | id         | c845db0c788443b4962b0717738ab0ce |
        | name       | demo                             |
        | project_id | fb76f73484554d3593964f24ec57bd05 |
        | username   | demo                             |
        +------------+----------------------------------+


.. tip::

    Run ``openstack project list`` to view a list of configured projects and ``openstack user list`` to view a list of configured users.

