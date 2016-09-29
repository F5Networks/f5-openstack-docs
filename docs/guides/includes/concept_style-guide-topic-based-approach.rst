The Topic-Based Approach
````````````````````````
 .. epigraph::

    Write once; [reuse] anywhere.

    -- Sun Microsystems

The original slogan for Java -- "write once, run anywhere" -- is a great way to describe the philosophy underlying content reuse in documentation. [#]_ Content reuse helps the doc writer avoid duplication, ensuring consistency and accuracy across the documentation set. It cuts down on the amount of time required to manage updates, since you don't have to find and update the same information in many different places. Additionally, it contributes to greater efficiency on a technical writing (or development) team, since individual writers don't each have to write the same information for their respective deliverables.

In order for a team to effectively reuse content, everyone has to follow the same approach to writing, structuring, and organizing their content. Enter topic based authoring.

The "topic based authoring" (TBA) approach to content creation and management revolves around the idea of standalone topics which can be used in many different contexts. In conjunction with its sister concept, `"minimalism" <https://en.wikipedia.org/wiki/Minimalism_(technical_communication)>`_, TBA is the core of F5's Technical Communications strategy.

The traditional TBA approach dictates that a topic can be one of three types: task, concept, or reference. We've simplified this into a more development-friendly approach, choosing instead to use the following three distinct types of content "chunks": topics, concepts, and references.

Topics, Concepts, and References
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

For the purposes of this guide, content "chunks" - any content which will be used as part of a larger document - are classified as topics, concepts, or references.

- A :dfn:`topic` is a content unit focused on one subject (usually a feature.[#]_
  A topic should conceivably be able to stand on its own, even if it's unlikely that it actually will. Topics contain all of the information relevant to a specific subject (e.g., overview, prerequisites, configuration options and instructions) and serves as the point from which information can be reused elsewhere. If you're describing a feature and providing instructions for its various configuration options, you're writing a topic.

- A :dfn:`concept` is like an overview: it presents key and/or background information about a topic.
  Generally, concepts are used to provide the context for user guides that reference or reuse a number of different topics. If you're explaining background or high-level information required to understand a subject or set of subjects, you're writing a concept.

- A :dfn:`reference` presents data or raw information that supplement or support the other content types.
  If you're organizing information into a table, you're writing a reference. References should not contained detailed background information (that's a concept) or instructions for how to do something (that's a topic).

.. seealso::

    **TBA resources**

    - `Topic-based authoring (wikipedia) <https://en.wikipedia.org/wiki/Topic-based_authoring>`_
    - `Topic-based authoring (dita-xml.org) <http://dita.xml.org/topic-based-authoring>`_
    - `What is a topic? What does standalone mean? (Every Page is Page One) <http://everypageispageone.com/2011/06/08/what-is-a-topic-what-does-standalone-mean/>`_

    The following extremely useful resources are only accessible by F5 employees:

    - `Four Principles of Minimalism <https://hive.f5.com/docs/DOC-14102>`_
    - `Tech Comm Authoring Guidelines <https://hive.f5.com/docs/DOC-14471>`_
