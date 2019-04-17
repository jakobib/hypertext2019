# Introduction

The original vision of hypertext as proposed by Ted Nelson
[@Nelson1965;@Nelson2007] still waits to be realized. His influence is visible
through people who, influenced by his works, shaped the computer world of
today, last but not least the Web [@Nelson2008].^[Tim Berners-Lee references
Nelson both in the proposal that led to the Web [@BernersLee1990;@Nelson1967]
and at the early W3C homepage <http://www.w3.org/Xanadu.html> (1992/93)
[@Nelson1980].] Nelson's core idea, a network of visibly connected documents
called Xanadu, goes beyond the Web in several aspects. In particular it
promises non-breaking links and it uses links to build documents (with
versions, quotations, overlay markup...) instead of using documents to build
links [@Nelson1997]. The concept of hypertext or more general 'hypermedia' has
also been used differing from Nelson, both in the literary community (that
focused on simple links), and in the hypertext research community (that focused
on tools) [@WardripFruin2004].

This paper tries to get back to the original vision of hypertext by
specification of a formal model that puts transcludeable documents at its
heart.  Apart from Nelson's works
[@Nelson1965;@Nelson1967;@Nelson1974;@Nelson1980;@Nelson1999;@Nelson2007] this
paper draws from research on data format analysis [@Voss2013a;@Kent1989],
content-based identifiers [@Trask2016;@Lukka2002], existing transclusion
technologies for the Web [@Akscyn2015;@Tennison2011;@IIIFImageAPI;@Csillag2013]
and hypertext systems beyond link-based models [@Atzenbeck2017].

Limited by the state of document processing tools and by submission guidelines,
this paper is not a demo of hypertext.^[See [@Capadisli2015] for a good example
of what an actual demo paper might look like.] On a closer look however there
are traces of transclusion links that have been processed to this paper. See
figure \ref{fig:demopaper} for an overview and
<https://github.com/jakobib/hypertext2019> for details and sources.

# Outline

The architecture of an infrastructure-agnostic hypertext system consists of four
basic elements and their relations:

1) **documents** include all finite, digital objects

1) **document identifiers** reference individual documents

2) **content locators** reference segments within documents

3) **edit list** combine parts of existing document into new ones

Instances of each element can further be grouped by **data formats**.  The
elements and their relations are each described in the following sections after
a formal definition.

## Formal model

A hypertext system is a tuple $\langle D,I,C,E,S,R,U,T,A \rangle$ where:

$D$
 : is a set of documents

$I$
 : is a set of document identifiers with $I \subset D$

$C$
 : is a set of content locators with $C \subset D$

$E$
 : is a set of edit lists with $E \subset D$

$S$
 : is a set of document segments with $S \subset C \times D$

Document sets can each be grouped into (possibly overlapping) data formats.
The hypertext system further consists of:

$R$
 : is a retrieval function with $R\colon I \to D$

$U$
 : is a segments usage function $U\colon E \to \mathcal{P}(S)$

$T$
 : is a transclusion function with $T\colon S \to D$

$A$
 : is an hypertext assemble function with $A\colon E \to D$

A practical hypertext system needs executable implementations of the functions
$R,U,T,A$ and a method to tell whether a given combination $\langle c,d \rangle
\in C \times D$ is part of $S$ to allow its use with $T$.

## Documents

A document is a finite sequence of bytes. This definition roughly equates with
the definition of data as documents [@Furner2016; @Voss2013b]. The notion of
hypertext used in this paper therefore subsumes all kinds of hyperdata
(datasets that transclude other datasets).  Documents are static by content
[@Renear2009] but they may be processed dynamically. Documents are grouped by
non-disjoint data formats such as UTF-8, CSV, SVG, PDF and many many more. 

## Document identifiers

A document identifier is a relatively short document that refers to another
document.  Identifiers have properties depending on the particular identifier
system they belong to [@Voss2013b, pp. 59-71]. Identifiers in
infrastructure-agnostic hypertext must first be *unambiguous* (an identifier
must reference only one document), *persistent* (the reference must not change
over time), and *actionable* (hypertext systems should provide methods to
retrieve documents via the retrieval function $R$). Properties that should be
fulfilled at least to some degree include *uniqueness* (a document should not
be referenced by too many identifiers), *performance* (identifiers should be
easy to compute and to validate), and *distributedness* (identifiers should not
require a central institution). The actual choice of an identifier system depends
on weighting of specific requirements. A promising choice is the application of 
content-based identifiers as proposed at least once in the context of
hypertext systems [@Lukka2002].

## Content locators

A content locator is a document that can be used to select parts of another
document via transclusion. Nelsons refers to this locators as "reference
pointers" [@Nelson1999], exemplified with spans of bytes or characters in a
document. Content locators depend on data formats and document models.  For
instance locator languages XPath, XPointer, and XQuery act on XML documents,
which can be serialized in different forms (therefore it makes no sense to
locate parts of an XML document with positions of bytes).  Other locator
languages apply to tabular data (SQL, RFC\ 7111), to graphs (SPARQL, GraphQL),
or to two-dimensional images (IIIF), to name a few.  Whether and how parts of a
document can be selected with a content locator language depends on which data
format the document is interpreted in. For instance an SVG image file can be
processed at least as image, as XML document, or as Unicode string, each with
its own methods of locating document segments.  Content locators can be
extended to all executable programs that reproducibly process some documents
into other documents. This generalization can be useful to track data
processing pipelines as hyperdata such as discussed for executable papers and
reproducible research. Restriction of content locators to less powerful query
languages might make sense from a security point of view.

## Edit Lists

An edit list is a document that describes how to construct a new document from
parts of other documents. Edit lists are known as *Edit Decision Lists* in
Xanadu and the idea was borrowed from film making [@Nelson1967]. Simplified
forms of edit lists are implemented in version control systems and in
collaborative tools such as wikis and real-time editing. Hypertext edit lists
go beyond this one-dimensional case by support of multiple source documents and
by more flexible methods of document processing in addition to basic operations
such as insert, delete, and replace. The actual processing steps tracked by an
edit list depend on data formats of transcluded documents.  Just like content
locators, edit lists could be extended to arbitrary executable programs that
implement the hypertext assemble function $A$ for some subset of edit lists. To
ensure reproducibility and reliable transclusion,^[If documents models/segments
change, locators may not be applicable anymore [@Csillag2013].] these programs
must not access unstable external information such as documents that may change
[@Renear2009].

## Data formats

An often neglected fundamental property of digital documents is their grounding
in data formats.  A data format is a set of documents that share a common data
model, also known as their document model, and a common serialization (see
fig.\ \ref{fig:datamodeling}).  Models define elements of a document in terms
of sets, strings, tuples, graphs or similar structures. These structures are
mathematically rigor in theory [@Renear2009] but more based on descriptive
patterns in practice [@Voss2013a].  The meaning of these elements (for instance
"words", "sentences", and "paragraphs" in a document model) is based on ideas
that we at least assume to be consistent among different people.

~~~{=html}
<figure>
<img src="levels-of-data-modeling.svg"/>
<figcaption>levels of data modeling</figcaption>
</figure>
~~~

~~~{=latex}
\begin{figure}
\Description{Three icons labeled `ideas`, `model`, `format`, and `serialization`, respectively}
\input{levels-of-data-modeling.tikz}
\caption{levels of data modeling}
\label{fig:datamodeling}
\end{figure}
~~~

Data modeling, the act of mapping between ideas, models, and formats is an
unsolved problem because ideas can be expressed in many models and models can
be interpreted in many ways [@Kent1989]. Data models can further be expressed
in multiple formats although these formats should fully be convertible between
each other, at least in theory.^[In practice it's often unknown whether two
data formats actually share the same model, especially if models are only given
implicitly by definition of their formats.] Formats can further be serialized
in multiple forms, which for their part are based on other data models.  For
instance the RDF model can be serialized in RDF/XML format which is based on
the XML model. XML can be serialized XML syntax which is based on the Unicode
model, and Unicode can be serialized in UTF-8. At the end of these chains of
abstraction eventually all documents can be serialized as sequence of bytes.
Serializations are seldom simple mappings as most serialization formats allow
insignificant variances such as additional whitespace. To check whether a data
object conforms to a serialization, formats are often described with a formal
grammar that can also give insights about the format's model.^[Formats may also
exist purely implicit in form of sample instances which grammar, model, and
ideas must be guessed from by reverse engineering [@Voss2013a].]
Infrastructure-agnostic hypertext does not impose any limits on possible data
formats and their models.

# Example

The following example may illustrate the formal model and its elements.  Let
$\langle D,I,C,E,S,R,U,T,A \rangle$ be a hypertext system with $D$ the set of
printable ASCII character strings and some documents:

$d_1$
  : = '`My name is Alice`'

$d_2$
  : = '`Alice`'

$c_1$
  : = '`char=11,15`'

$d_3$
  : = '`Hello, !`'

$c_2$
  : = '`char=7`'

$d_4$
  : = '`Hello, Alice!`'

If $c_1$ and $c_2$ are read in content locator syntax as defined by RFC\ 5147
so that $T(\langle c_1,d_1 \rangle) = d_2$
then $d_4$ can be constructed by transcluding a document segment of
$d_1$ into $d_3$ at position $c_2$. 
The corresponding edit list $e_1 \in E$ with $A(e_1)=d_4$ could look like this:

~~~
 take      995f37f2e066b7d8893873ca4d780da5bf017184
 insert at 48ba94c47b45390b6dd27824cfc0d8468c2cbc71
 from      fcb59267e2e6641140578235c8cb6d38eaf6abc1
 segment   c5b794c7ae5d490f52a414d9d19311b9a19f61b3
~~~

The hexademical values in $e_1$ are SHA-1 hashes of $d_3$, $c_2$, $d_1$, and
$c_1$ respectively.^[A more practical edit list syntax $E$ could also allow to
directly embeded small document instances which SHA-1 hashes can be computed
from. If implemented carefully, this could also reconcile transclusion with
copy-and-paste.] Retrieval function $R$ maps them back to strings. Hyperlinks
are given by $U(e_1) = \{ \langle c_2,d_3 \rangle,  \langle c_1,d_1 \rangle
\}$, the first link used for editing $d_3$ to $d_4$ (versioning) and the second
for referencing of segment of $d_1$ in $d_4$ (transclusion).

# Implementations

<!--The infrastructure-agnostic model of hypertext helps to analyze hypertext systems
but its ultimate goal is guidance to actual xanalogical implementations. --> One of
the problems faced by project Xanadu was it long required new developments such
as computer networks, document processing, and graphical user interfaces ahead
of their time. Today we can build on a many existing technologies:

networks:
  : storage and communication networks are ubiquitous with several protocols
    (HTTP, IPFS, BitTorrent...).

identifier systems:
  : document identifiers should be part of the URI/IRI identifier system.
    More specific candidates of relevant identifier systems include URLs and
    content-based identifiers.

formats:
  : hypertext systems should not be limited to their own document formats
    (such as the Web's focus on HTML/DOM) but allow for integration
    of all kinds of digital objects.
 
content locators
  : as shown above, several content locator and query formats exist, at
    least for some document models.

Access to documents via a retrieval function $R$ can be implemented with
existing network and identifier technologies. The easiest solution would be to
build on top of HTTP and URL but these identifiers are far from unambiguous and
persistent. Content-based identifiers guarantee to always reference the same
document but they require network and storage systems to be actionable.^[New
standards such as IPFS Mulihashes and BitTorrent Merkle-Hashes look promising
but these types of identifiers are not specified as part of the URI system
(yet) [@Trask2016].]

The set of supported data formats is only limited by availability of
applications to view and to edit documents. Full integration into a hypertext
system however requires appropriate content locator formats to select,
transclude, and link to segments from these documents. Existing content locator
technologies include URI Fragment Identifiers [@Tennison2011], patch file
formats (JSON Patch, XML Patch, LD Patch...), and domain-specific query
languages as long as they can guarantee reproducible builds.  Two projects that
popularized at least a simple form of transclusion on the Web are hypothes.is
with a combination of locator methods [@Csillag2013] and the IIIF Image API
with focus on content locators in images [@IIIFImageAPI].

## Challenges

Despite the availability of technologies to build on, creation of a xanalogical
hypertext system is challenging for several reasons. The general problems
involved with transclusion have been identified [@Akscyn2015]. Other or more
specific challenges include (ordered by severity):

storage:
  : data storage is cheap, but someone has to pay for it.

normalization:
  : most documents (including identifiers) can be serialized in
    different forms. To support unique document identifiers, a
    hypertext system should support normalization of documents
    to canonical forms.

link services:
  : databases of links have been proposed as central part of
    Open Hypermedia Systems [@Atzenbeck2017] but they are not
    available for the Web because of commercial interest.^[In
    particular by search engines and by spammers. A 
    criteria to judge the success of a hypertext system is
    whether it is popular enough to attract link spam.]
    Links are ideally derived from edit lists with segments
    usage function $U$.  Recent development such as Webmention
    and OpenCitation may help to improve collection of links.

visualization and navigation:
  : this most recognizable element of hypertext has mostly been reduced
    to simple links while Nelson's ideas seem to have been forgotten or
    ignored [@Viegas2003]. Nevertheless the creation of tools for 
    visualization and navigation in hypertext structures is less
    challenging then getting hold of the underlying documents and hyperlinks.

edit list formats
  : despite edit lists being the very core of the idea of hypertext
    [@Nelson1967], they have rarely been implemented in reusable data
    formats. Proper hypertext implementations
    therefore require to establish new formats with support of
    hypertext assemble function $A$ and segments usage function $U$.
 
editing tools
  : applications to create and modify digital objects track changes
    dont't provide this information in form of reusable edit lists,
    if at all. Hypermedia authoring needs to be integrated into
    existing editing tools to succed [@DiIorio2005].

copyright and control:
 : who should be allowed to use which documents under which conditions?
   The answers primarily depend on legal, social, and political requirements.

## Differences to Xanadu

Project Xanadu promised a comprehensive hypertext system including elements for
content (xanadocs), network (servers), rights (micropayment), and interface
(viewers) -- years before each these concept made it into the computer
mainstream.  Given the current state of technology, a xanalogical hypertext
system does not need to implement all elements. The infrastructure-agnostic
model of hypertext tries to capture the core parts of the original vision of
hypertext by concentrating on its documents and document formats. For this
reason some requirements listed by Xanadu Australia [@Pam2002] or mentioned by
Nelson in other publications are not incorporated explicitly:

a) identified servers as canonical sources of documents
b) identified users and access control
c) copyright and royalty system via micropayment
d) user interfaces to navigate and edit hypertexts

Meeting these requirements in actual implementations is possible nevertheless.
Identified servers (a) and users (b) were part of *Tumbler* identifers (that
combined document identifiers and content locators) [@Nelson1980] but the
current OpenXanadu implementation uses plain URLs as part of its *Xanadoc* edit
list format [@Nelson2014]. Canonical sources of documents (a) could also be
implemented by blockchains or alternative technology to proof that a specific
document existed on a specific server at a specific time. Such knowledge of a
document's first insertion into the hypertext system would also allow for
royalty systems (c).^[Copyright detection was easy to implement with mandatory
registration such as partly required in the United States until 1976. Authors
might also register documents with cryptographic hashes without making them
public in the first place.] Identification of users and access control (b)
could also be implemented in several ways but this feature much more depends on
network infrastructures and socio-technical environments, including rules of
privacy, intellectual property, and censorship.
Last but not least, a hypertext system needs applications to visualize,
navigate, and edit hypermedia (d)^[Tim Berners-Lee's first Web browser
originally supported editing.] Several user interface have been invented in the
history of hypertext [@MProve2002] and there will unlikely be one final
application because user interfaces depend on use-cases and file formats.

# Summary and conclusion

This paper presents a novel interpretation of the original vision of hypertext
[@Nelson1965;@Nelson1967]. The infrastructure-agnostic model of hypertext does
not require or exclude specific data formats or network protocols. Abstract
from these ever-changing technologies, the focus is on hypermedia *content*
(documents) and *connections* (hyperlinks). The basic elements of a hypertext
system are identified as documents, document identifiers, content locators, and
edit lists with a formal model that defines their relations based on knowledge
of data formats and models. It is shown which
technologies can be used to implement such a hypertext system integrated into
current information infrastructures (in particular the Internet and the Web)
and which challenges still exist (in particular support of edit lists in
editing tools). 

<!--
Ironically Berners-Lee seems to have aimed at a more Xanalogic
hypertext system but he found standardization of hypertext too
much focused on "the format for exchangeable media"
document formats than on protocols so he created HTTP. [@BernersLee1990]
-->

<!-- TODO: Image of "windowing" into documents? -->

~~~{=html}
<figure>
<img src="this-articles-transclusion.svg"/>
<figcaption>Proto-transclusion links of this paper</figcaption>
</figure>
~~~

~~~{=latex}
\begin{figure}
\Description{Several data formats connected by arrows}
\input{this-articles-transclusion.tikz}
\caption{Proto-transclusion links of this paper}
\label{fig:demopaper}
\end{figure}
~~~

