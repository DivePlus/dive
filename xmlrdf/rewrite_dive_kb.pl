:- module(rewrite_dive,
	  [ rewrite_oi/0,
	    rewrite_oi/1,
	    rewrite_oi/2,
	    list_rules/0
	  ]).
:- use_module(library(semweb/rdf_db)).
:- use_module(library(xmlrdf/rdf_convert_util)).
:- use_module(library(xmlrdf/cvt_vocabulary)).
:- use_module(library(xmlrdf/rdf_rewrite)).
:- use_module(library(http/http_open)).

:- debug(rdf_rewrite).

%%	rewrite
%
%	Apply all rules on the graph =data=

rewrite_oi :-
	rdf_rewrite(data).

%%	rewrite(+Rule)
%
%	Apply the given rule on the graph =data=

rewrite_oi(Rule) :-
	rdf_rewrite(data, Rule).

%%	rewrite(+Graph, +Rule)
%
%	Apply the given rule on the given graph.

rewrite_oi(Graph, Rule) :-
	rdf_rewrite(Graph, Rule).

%%	list_rules
%!
%	List the available rules to the console.

list_rules :-
	rdf_rewrite_rules.

:- discontiguous
	rdf_mapping_rule/5.


% if actors with same name: produce link -> only do within a graph

collapse_actor
@@
{S,rdf:type,sem:'Actor'},
{S1,rdf:type,sem:'Actor'},
{S,rdfs:label, Lab},
{S1,rdfs:label, Lab}\
{S}
<=>
S\=S1,
{S1}.

collapse_place
@@
{S,rdf:type,sem:'Place'},
{S1,rdf:type,sem:'Place'},
{S,rdfs:label, Lab},
{S1,rdfs:label, Lab}\
{S}
<=>
S\=S1,
{S1}.

collapse_event
@@
{S,rdf:type,sem:'Event'},
{S1,rdf:type,sem:'Event'},
{S,rdfs:label, Lab},
{S1,rdfs:label, Lab}\
{S}
<=>
S\=S1,
{S1}.

collapse_time
@@
{S,rdf:type,sem:'Time'},
{S1,rdf:type,sem:'Time'},
{S,rdfs:label, Lab},
{S1,rdfs:label, Lab}\
{S}
<=>
S\=S1,
{S1}.

kb_thumbnails
@@
{S,dive:placeholder,PL}
<=>
kb_thumb(PL,New),
 {S,dive:placeholder,New}.


add_description
@@
{S,rdf:type,dive:'Entity'}
==>
not(rdf(S,dcterms:description)),
{S,dcterms:description, 'description'}.



kb_thumb(PL,New):-
sub_atom(PL,_,_,_,'http://resolver.kb'),
 catch(http_open(PL,St,[final_url(U),timeout(2)]),_,fail),
 atomic_list_concat([
  'http://imageviewer.kb.nl/ImagingService/imagingService?id=',
		   U,
		   '&zoom=0.20&useresolver=false'],
		  New),
 close(St),
 write('.'),flush.

