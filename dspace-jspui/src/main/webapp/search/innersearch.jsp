<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>
<%--
  - fragment JSP to be included in site, community or collection home to show discovery facets
  -
  - Attributes required:
  -    discovery.fresults    - the facets result to show
  -    discovery.facetsConf  - the facets configuration
  -    discovery.searchScope - the search scope 
  --%>

<%@page import="org.dspace.discovery.configuration.DiscoverySearchFilterFacet"%>
<%@ page import="java.util.HashMap"%>
<%@ page import="java.util.Set"%>
<%@ page import="java.util.Map"%>
<%@ page import="org.dspace.discovery.DiscoverResult.FacetResult"%>
<%@ page import="java.util.List"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="org.apache.commons.lang.StringUtils"%>

<div class="discovery-search-form panel panel-default">

	<div class="discovery-query panel-heading">
		<form action="/simple-search" method="get">
			<label for="tlocation"> Search: </label> <select name="location"
				id="tlocation">


				<option selected="selected" value="/">All of DSpace</option>

				<option value="123456789/4">Doutrina</option>

				<option value="123456789/15">Repositório Institucional</option>
			</select><br> <label for="query">for</label> <input type="text" size="50"
				id="query" name="query" value="testeaaaa"> <input
				type="submit" id="main-query-submit" class="btn btn-primary"
				value="Go"> <input type="hidden" value="10" name="rpp">
			<input type="hidden" value="score" name="sort_by"> <input
				type="hidden" value="desc" name="order"> <a
				class="btn btn-default" href="/jspui/simple-search">Start a new
				search</a>
		</form>
	</div>

	<div class="discovery-search-filters panel-body">
		<h5>Add filters:</h5>
		<p class="discovery-search-filters-hint">Use filters to refine the
			search results.</p>
		<form action="simple-search" method="get">
			<input type="hidden" value="" name="location"> <input
				type="hidden" value="testeaaaa" name="query"> <select
				id="filtername" name="filtername">
				<option value="title">Title</option>
				<option value="author">Author</option>
				<option value="subject">Subject</option>
				<option value="dateIssued">Date Issued</option>
			</select> <select id="filtertype" name="filtertype">
				<option value="equals">Equals</option>
				<option value="contains">Contains</option>
				<option value="authority">ID</option>
				<option value="notequals">Not Equals</option>
				<option value="notcontains">Not Contains</option>
			</select> <span role="status" aria-live="polite"
				class="ui-helper-hidden-accessible"></span><input type="text"
				id="filterquery" name="filterquery" size="45"
				class="ui-autocomplete-input" autocomplete="off"> <input
				type="hidden" value="10" name="rpp"> <input type="hidden"
				value="score" name="sort_by"> <input type="hidden"
				value="desc" name="order"> <input class="btn btn-default"
				type="submit" value="Add">
		</form>
	</div>


	<div class="discovery-pagination-controls panel-footer">
		<form action="simple-search" method="get">
			<input type="hidden" value="" name="location"> <input
				type="hidden" value="testeaaaa" name="query"> <label
				for="rpp">Results/Page</label> <select name="rpp">

				<option value="5">5</option>

				<option value="10" selected="selected">10</option>

				<option value="15">15</option>

				<option value="20">20</option>

				<option value="25">25</option>

				<option value="30">30</option>

				<option value="35">35</option>

				<option value="40">40</option>

				<option value="45">45</option>

				<option value="50">50</option>

				<option value="55">55</option>

				<option value="60">60</option>

				<option value="65">65</option>

				<option value="70">70</option>

				<option value="75">75</option>

				<option value="80">80</option>

				<option value="85">85</option>

				<option value="90">90</option>

				<option value="95">95</option>

				<option value="100">100</option>

			</select> &nbsp;|&nbsp; <label for="sort_by">Sort items by</label> <select
				name="sort_by">
				<option value="score">Relevance</option>
				<option value="dc.title_sort">Title</option>
				<option value="dc.date.issued_dt">Issue Date</option>
			</select> <label for="order">In order</label> <select name="order">
				<option value="ASC">Ascending</option>
				<option value="DESC" selected="selected">Descending</option>
			</select> <label for="etal">Authors/record</label> <select name="etal">

				<option value="0" selected="selected">All</option>
				<option value="1">1</option>
				<option value="5">5</option>

				<option value="10">10</option>

				<option value="15">15</option>

				<option value="20">20</option>

				<option value="25">25</option>

				<option value="30">30</option>

				<option value="35">35</option>

				<option value="40">40</option>

				<option value="45">45</option>

				<option value="50">50</option>

			</select> <input class="btn btn-default" type="submit" name="submit_search"
				value="Update">
		</form>
	</div>
</div>