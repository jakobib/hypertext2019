# Introduction

The original vision of hypertext as proposed by Ted Nelson
[@Nelson1965;@Nelson2007] still waits to be realized.  Hypertext (subsuming
hypermedia and hyperdata) has also been understood differently both in the
literary community (that focused on simple links), and in the hypertext
research community (that focused on tools) [@WardripFruin2004]. Infrastructure
agnostic hypertext is an attempt to recover the core parts of original
hypertext by concentrating on documents and their connections.^[An earlier and
more detailled version of this publication (4 pages) is available at
<https://arxiv.org/abs/1907.00259> (PDF) and
<https://jakobib.github.io/hypertext2019/> (HTML).]

# Outline of Hypertext

**Documents** ($D$) are all finite sequences of bytes, including

* **document identifiers** ($I$) to reference individual documents,

* **content locators** ($C$) to reference segments within documents,

* **edit lists** ($E$) to combine (parts of) document into new ones,

* and **document segments** with $S \subset C \times D$.

Documents are further grouped by a plethora of non-disjoint **data formats**,
such as UTF-8, CSV, and SVG. A hypertext system needs 

* a retrieval function $R\colon I \to D$ to get documents,

* a transclusion function $T\colon S \to D$ to get document segments,

* an assemble function $A\colon E \to D$ to execute edit lists,

* a segments usage function $U\colon E \to \mathcal{P}(S)$ for backlinks,

and practical methods to tell which content locators can be used with which
documents to form an actual document segment. The core elements of hypertext,
except from the simple parts documents and document identifiers, require some
explanation.

## Data formats

A data format is a set of documents that share a common data/document model,
and a common serialization (see fig.\ \ref{fig:datamodeling}). The Dexter
Hypertext Reference Model assigned formats to the "within-component" layer
without further analysis because "it would be folly to attempt a generic model
covering all of these data types" [@Halasz1990]. Infrastructure-agnostic
hypertext however requires knowledge of data formats and models to support
integration of any kind of document. The challenge that hypertext systems need
to address is the unsolved problem of data modeling: ideas can be expressed in
many models, models can be interpreted in many ways, models and formats are
often not given explicitly [@Kent1989; @Voss2013a].

~~~{=html}
<figure>
<img src="levels-of-data-modeling.svg" width="60%"/>
<figcaption>levels of data modeling</figcaption>
</figure>
~~~

~~~{=latex}
\begin{figure}
\Description{Three icons labeled `ideas`, `model`, `format`, and `serialization`, respectively}
\input{../levels-of-data-modeling.tikz}
\caption{levels of data modeling}
\label{fig:datamodeling}
\end{figure}
~~~

## Content locators

Hypertext documents are primarily grounded in content locators for transclusion
of document segments and in edit lists to create new documents.  A content
locator is a document that can be used to select parts of another document via
transclusion. Nelsons refers to these locators as "reference pointers"
[@Nelson1999], exemplified with spans of bytes or characters in a document.
Whether and how parts of a document can be selected with a content locator
language depends on which data format the document is interpreted in. For
instance a SVG document can at least be seen as two-dimensional image, as XML
tree, and as sequence of Unicode characters. Possible locator languages include
IIIF for the first data format and XPath, XPointer, and XQuery for the second.
Other locator languages apply for instance to tabular data (SQL, RFC\ 7111) or
to graphs (SPARQL, GraphQL). Existing locator technologies further include URI
Fragment Identifiers, patch formats (JSON Patch, XML Patch, LD Patch), and
domain-specific query languages: content locators can be extended to all
executable programs that reproducibly transform documents into other documents.
This generalization can be useful to track data processing pipelines as
hyperdata such as discussed for executable papers and reproducible research.
 
## Edit Lists

Edit lists, known as *Edit Decision Lists* in Xanadu and borrowed from film
making [@Nelson1967], are documents consisting of references to document
segments and rules how to combine them into new documents. Several applications
to create and modify digital objects track changes but this information is not
provided in form of reusable edit lists, if at all. Hypermedia authoring should
be integrated into existing editing tools [@DiIorio2005] and their changelogs.
Simplified forms of edit lists are implemented in version control systems and
in collaborative editing tools. Hypertext edit lists go beyond this
one-dimensional case by support of multiple source documents and by more
flexible methods of document processing (in addition to basic operations such
as insert, delete, and replace). The actual processing steps tracked by an edit
list depend on data formats of transcluded documents.  Just like content
locators, edit lists can be extended to arbitrary executable programs that
reproducibly emit documents.

## Link services

Links services have been proposed as central part of Open Hypermedia Systems
[@Atzenbeck2017].  On the Web they are not available openly because of
commercial interest.^[By search engines and by spammers. A criterion to judge
the success of a hypertext system may be whether it is popular enough to
attract link spam.] Hypertext systems can derive links from edit lists, but the
challenge is to establish link services that collect and share these links.
Recent development such as Webmention and OpenCitation may help here.

## Document retrieval 

Access to documents via a retrieval function $R$ can be implemented with
existing network and identifier technologies (basically HTTP and URL) as done
in OpenXanadu [@Nelson2014] but content-based identifiers better guarantee to
always reference the same document [@Lukka2002]. Promising technologies for
implementation include IPFS Mulihashes and BitTorrent Merkle-Hashes. The
challenge of hypertext systems is less the technical infrastructure to retrieve
documents but normalization of documents to canonical forms to support
content-based identifiers.

# Summary and conclusion

Infrastructure-agnostic hypertext focuses on hypermedia *content* (documents)
and *connections* (hyperlinks). Its model allows for integration of all kinds
of data. The agnosticism to ever changing technologies excludes only some
Xanadu requirements [@Pam2002]:

a) identified servers as canonical sources of documents and
b) identified users and access control were part of *Tumblers* [@Nelson1980]
c) copyright and royalty system via micropayment
d) user interfaces to navigate and edit hypertexts

With documents as primary elements, document identifiers are a preferred over
servers and users.^[OpenXanadu also uses plain URLs as part if its edit list
format [@Nelson2014].] Canonical sources of documents (authorship) could be
implemented with blockchain or other trusted logfiles. User interfaces highly
depend on use-cases and data formats anyway. What's needed for xanalogical
hypertext systems are efforts to understand, normalize and process file formats
in order to implement and popularize an ecosystem of content locators and edit
lists.  References to existing technologies show that hypertext as envisioned
by Ted Nelson can be integrated into current information infrastructures,
especially the Internet and the Web.
 
<!-- TODO: link to traces of transclusion links that have been processed to
this paper. See <https://github.com/jakobib/hypertext2019> and XXX for details
and sources.  -->

