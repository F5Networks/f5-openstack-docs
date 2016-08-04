How to Create Feature Documentation
===================================

To create documentation for your new feature, follow the directions provided below.

.. topic:: Create a new doc from the feature template.

    1. Look in the :file:`*/docs/includes` directory for a file with "template_for_new_features" in the filename.

        .. note:: The exact name may vary slightly from project to project.

    2. Copy and paste the template into a new file. Name the new file according to the recommended :ref:`naming conventions <File Names>`.

    3. Copy and paste any prerequisites from the master list (:file:`*/docs/includes/prerequisites-for-reuse.rst`) into your new doc.

        - Maintain the same order used in the master list in your document. This ensures continuity across all feature docs.
        - If you create a new prereq, **add it to the master list**.

.. sidebar:: Tips from the Technical Writing Field:

    - `The Key to Writing Good Documentation: Testing your Instructions <http://idratherbewriting.com/2015/07/07/testing-your-instructions/>`_
    - `How GitHub uses GitHub to Document GitHub <http://videos.writethedocs.org/video/96/how-github-uses-github-to-document-github>`_
    - `How to Write Documentation for People that Don't Read <http://videos.writethedocs.org/video/82/how-to-write-documentation-for-people-that-dont>`_
    - `User-Story Driven Docs <http://videos.writethedocs.org/video/87/user-story-driven-docs>`_

.. topic:: Document your feature.

    Things to keep in mind:

    - Review the :ref:`style guide <style_guide>` if you're unsure how to begin, what tools to use, etc..
    - Be clear.
    - Be concise.
    - Keep it high-level; we write primarily for the 80% case. Corner cases can be addressed as needed.

.. topic:: Committing and Pull Requests

    Commit your documentation changes and include them in the pull request you submit for your feature. Use the GitHub ``@`` mention tool to include all of the appropriate reviewers in your pull request (including your docs reviewer!).


