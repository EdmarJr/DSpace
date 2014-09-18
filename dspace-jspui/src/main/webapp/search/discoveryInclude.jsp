<%--

    The contents of this file are subject to the license and copyright
    detailed in the LICENSE and NOTICE files at the root of the source
    tree and available online at

    http://www.dspace.org/license/

--%>

<%--
  - Display the form to refine the simple-search and dispaly the results of the search
  -
  - Attributes to pass in:
  -
  -   scope            - pass in if the scope of the search was a community
  -                      or a collection
  -   scopes 		   - the list of available scopes where limit the search
  -   sortOptions	   - the list of available sort options
  -   availableFilters - the list of filters available to the user
  -
  -   query            - The original query
  -   queryArgs		   - The query configuration parameters (rpp, sort, etc.)
  -   appliedFilters   - The list of applied filters (user input or facet)
  -
  -   search.error     - a flag to say that an error has occurred
  -   spellcheck	   - the suggested spell check query (if any)
  -   qResults		   - the discovery results
  -   items            - the results.  An array of Items, most relevant first
  -   communities      - results, Community[]
  -   collections      - results, Collection[]
  -
  -   admin_button     - If the user is an admin
  --%>

<%@page import="org.dspace.discovery.configuration.DiscoverySearchFilterFacet"%>
<%@page import="org.dspace.app.webui.util.UIUtil"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.dspace.discovery.DiscoverFacetField"%>
<%@page import="org.dspace.discovery.configuration.DiscoverySearchFilter"%>
<%@page import="org.dspace.discovery.DiscoverFilterQuery"%>
<%@page import="org.dspace.discovery.DiscoverQuery"%>
<%@page import="org.apache.commons.lang.StringUtils"%>
<%@page import="java.util.Map"%>
<%@page import="org.dspace.discovery.DiscoverResult.FacetResult"%>
<%@page import="org.dspace.discovery.DiscoverResult"%>
<%@page import="org.dspace.content.DSpaceObject"%>
<%@page import="java.util.List"%>
<%@ page contentType="text/html;charset=UTF-8" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"
    prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core"
    prefix="c" %>

<%@ taglib uri="http://www.dspace.org/dspace-tags.tld" prefix="dspace" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ page import="java.net.URLEncoder"            %>
<%@ page import="org.dspace.content.Community"   %>
<%@ page import="org.dspace.content.Collection"  %>
<%@ page import="org.dspace.content.Item"        %>
<%@ page import="org.dspace.search.QueryResults" %>
<%@ page import="org.dspace.sort.SortOption" %>
<%@ page import="java.util.Enumeration" %>
<%@ page import="java.util.Set" %>
<%
    // Get the attributes
    String searchScopeTemp = searchScope.substring(8);
    DSpaceObject scope = (DSpaceObject) request.getAttribute("scope" );
    List<DSpaceObject> scopes = (List<DSpaceObject>) request.getAttribute("scopes");
    List<String> sortOptions = (List<String>) request.getAttribute("sortOptions");

    String query = (String) request.getAttribute("query");
	if (query == null)
	{
	    query = "";
	}
    Boolean error_b = (Boolean)request.getAttribute("search.error");
    boolean error = (error_b == null ? false : error_b.booleanValue());
    
    DiscoverQuery qArgs = (DiscoverQuery) request.getAttribute("queryArgs");
    String sortedBy = qArgs != null ? qArgs.getSortField() : null;
    String order = qArgs != null ? qArgs.getSortOrder().toString() : null;
    String ascSelected = (SortOption.ASCENDING.equalsIgnoreCase(order)   ? "selected=\"selected\"" : "");
    String descSelected = (SortOption.DESCENDING.equalsIgnoreCase(order) ? "selected=\"selected\"" : "");
    String httpFilters ="";
	String spellCheckQuery = (String) request.getAttribute("spellcheck");
    List<DiscoverySearchFilter> availableFilters = (List<DiscoverySearchFilter>) request.getAttribute("availableFilters");
	List<String[]> appliedFilters = (List<String[]>) request.getAttribute("appliedFilters");
	List<String> appliedFilterQueries = (List<String>) request.getAttribute("appliedFilterQueries");
	if (appliedFilters != null && appliedFilters.size() >0 ) 
	{
	    int idx = 1;
	    for (String[] filter : appliedFilters)
	    {
	        httpFilters += "&amp;filter_field_"+idx+"="+URLEncoder.encode(filter[0],"UTF-8");
	        httpFilters += "&amp;filter_type_"+idx+"="+URLEncoder.encode(filter[1],"UTF-8");
	        httpFilters += "&amp;filter_value_"+idx+"="+URLEncoder.encode(filter[2],"UTF-8");
	        idx++;
	    }
	}
	Integer auxByEdmar = ((Integer) request.getAttribute("etal"));
    int rpp          = qArgs != null ? qArgs.getMaxResults() : 0;
    int etAl         = auxByEdmar != null ? auxByEdmar.intValue() : 0 ;

    String[] options = new String[]{"equals","contains","authority","notequals","notcontains","notauthority"};
    
    // Admin user or not
    Boolean admin_b_include = (Boolean)request.getAttribute("admin_button");
    boolean admin_button_discovery_include = (admin_b_include == null ? false : admin_b_include.booleanValue());
%>

<c:set var="dspace.layout.head.last" scope="request">
<script type="text/javascript">
	var jQ = jQuery.noConflict();
	jQ(document).ready(function() {
		jQ( "#spellCheckQuery").click(function(){
			jQ("#query").val(jQ(this).attr('data-spell'));
			jQ("#main-query-submit").click();
		});
		jQ( "#filterquery" )
			.autocomplete({
				source: function( request, response ) {
					jQ.ajax({
						url: "<%= request.getContextPath() %>/json/discovery/autocomplete?query=<%= URLEncoder.encode(query,"UTF-8")%><%= httpFilters.replaceAll("&amp;","&") %>",
						dataType: "json",
						cache: false,
						data: {
							auto_idx: jQ("#filtername").val(),
							auto_query: request.term,
							auto_sort: 'count',
							auto_type: jQ("#filtertype").val(),
							location: '<%= searchScopeTemp %>'	
						},
						success: function( data ) {
							response( jQ.map( data.autocomplete, function( item ) {
								var tmp_val = item.authorityKey;
								if (tmp_val == null || tmp_val == '')
								{
									tmp_val = item.displayedValue;
								}
								return {
									label: item.displayedValue + " (" + item.count + ")",
									value: tmp_val
								};
							}))			
						}
					})
				}
			});
	});
</script>		
</c:set>


    <%-- <h1>Search Results</h1> --%>


<div class="discovery-search-form panel panel-default">
    <%-- Controls for a repeat search --%>
	<div class="discovery-query panel-heading">
    <form action="/jspui/simple-search" method="get">
         <label for="tlocation">
         	<fmt:message key="jsp.search.results.searchin"/>
         </label>
         <select name="location" id="tlocation" hidden="true">
<%
    if (scope == null)
    {
        // Scope of the search was all of DSpace.  The scope control will list
        // "all of DSpace" and the communities.
%>
                                    <%-- <option selected value="/">All of DSpace</option> --%>
                                    <option selected="selected" value="/"><fmt:message key="jsp.general.genericScope"/></option>
<%  }
    else
    {
%>
									<option value="/"><fmt:message key="jsp.general.genericScope"/></option>
<%  }
if(scopes != null) {
    for (DSpaceObject dso : scopes)
    {
%>
                                <option value="<%= dso.getHandle() %>" <%=dso.getHandle().equals(searchScopeTemp)?"selected=\"selected\"":"" %>>
                                	<%= dso.getName() %></option>
<%
    }
}
%>                                </select><br/>
                               
                               
                               
                                <label for="filter_value_1"><fmt:message key="jsp.pesquisa.byedmar.tipodocumento"/></label>
                                <select id="filter_field_1" name="filter_field_1" hidden="true">
									<option value="type" selected="selected">Title</option>
								</select>
                                <select id="filter_type_1" name="filter_type_1" hidden="true">
									<option value="contains" selected="selected"><fmt:message key="jsp.search.filter.op.contains"/></option>
								</select>
                                <input type="text" id="filter_value_1" name="filter_value_1" value="" size="45"><br/>
                                
                                
                                <label for="filter_value_2"><fmt:message key="jsp.pesquisa.byedmar.numerodocumento"/></label>
                                <select id="filter_field_2" name="filter_field_2" hidden="true">
									<option value="number" selected="selected">Number</option>
								</select>
                                <select id="filter_type_2" name="filter_type_2" hidden="true">
									<option value="contains" selected="selected"><fmt:message key="jsp.search.filter.op.contains"/></option>
								</select>
                                <input type="text" id="filter_value_2" name="filter_value_2" value="" size="45"><br/>
                                
                                <label for="filter_value_3"><fmt:message key="jsp.pesquisa.byedmar.anodocumento"/></label>
                                <select id="filter_field_3" name="filter_field_3" hidden="true">
									<option value="year" selected="selected">Year</option>
								</select>
                                <select id="filter_type_3" name="filter_type_3" hidden="true">
									<option value="contains" selected="selected"><fmt:message key="jsp.search.filter.op.contains"/></option>
								</select>
                                <input type="text" id="filter_value_3" name="filter_value_3" value="" size="45"><br/>
                                
                                <label for="filter_value_4"><fmt:message key="jsp.pesquisa.byedmar.assuntodocumentonew"/></label>
                                <select id="filter_field_4" name="filter_field_4" hidden="true">
									<option value="subjectNew" selected="selected">Subject New</option>
								</select>
                                <select id="filter_type_4" name="filter_type_4" hidden="true">
									<option value="contains" selected="selected"><fmt:message key="jsp.search.filter.op.contains"/></option>
								</select>
                                <input type="text" id="filter_value_4" name="filter_value_4" value="" size="45"><br/>
            
                            
                                <label for="query"><fmt:message key="jsp.pesquisa.byedmar.pesquisa.geral"/></label>
                                <input type="text" size="50" id="query" name="query" value="<%= (query==null ? "" : StringEscapeUtils.escapeHtml(query)) %>"/>
                                <input type="submit" id="main-query-submit" class="btn btn-primary" value="<fmt:message key="jsp.general.go"/>" />
<% if (StringUtils.isNotBlank(spellCheckQuery)) {%>
	<p class="lead"><fmt:message key="jsp.search.didyoumean"><fmt:param><a id="spellCheckQuery" data-spell="<%= StringEscapeUtils.escapeHtml(spellCheckQuery) %>" href="#"><%= spellCheckQuery %></a></fmt:param></fmt:message></p>
<% } %>                  
                                <input type="hidden" value="<%= rpp %>" name="rpp" />
                                <input type="hidden" value="<%= sortedBy %>" name="sort_by" />
                                <input type="hidden" value="<%= order %>" name="order" />
<% if (appliedFilters != null && appliedFilters.size() > 0 ) { %>                                
		<div class="discovery-search-appliedFilters">
		<span><fmt:message key="jsp.search.filter.applied" /></span>
		<%
			int idx = 1;
			for (String[] filter : appliedFilters)
			{
			    boolean found = false;
			    %>
			    <select id="filter_field_<%=idx %>" name="filter_field_<%=idx %>">
				<%
					for (DiscoverySearchFilter searchFilter : availableFilters)
					{
					    String fkey = "jsp.search.filter."+searchFilter.getIndexFieldName();
					    %><option value="<%= searchFilter.getIndexFieldName() %>"<% 
					            if (filter[0].equals(searchFilter.getIndexFieldName()))
					            {
					                %> selected="selected"<%
					                found = true;
					            }
					            %>><fmt:message key="<%= fkey %>"/></option><%
					}
					if (!found)
					{
					    String fkey = "jsp.search.filter."+filter[0];
					    %><option value="<%= filter[0] %>" selected="selected"><fmt:message key="<%= fkey %>"/></option><%
					}
				%>
				</select>
				<select id="filter_type_<%=idx %>" name="filter_type_<%=idx %>">
				<%
					for (String opt : options)
					{
					    String fkey = "jsp.search.filter.op."+opt;
					    %><option value="<%= opt %>"<%= opt.equals(filter[1])?" selected=\"selected\"":"" %>><fmt:message key="<%= fkey %>"/></option><%
					}
				%>
				</select>
				<input type="text" id="filter_value_<%=idx %>" name="filter_value_<%=idx %>" value="<%= StringEscapeUtils.escapeHtml(filter[2]) %>" size="45"/>
				<input class="btn btn-default" type="submit" id="submit_filter_remove_<%=idx %>" name="submit_filter_remove_<%=idx %>" value="X" />
				<br/>
				<%
				idx++;
			}
		%>
		</div>
<% } %>
<a class="btn btn-default" href="<%= request.getContextPath()+"/simple-search?location="+searchScopeTemp %>"><fmt:message key="jsp.pesquisa.byedmar.pesquisaavancada" /></a>	
		</form>
		</div>

        <%-- Include a component for modifying sort by, order, results per page, and et-al limit --%>
   
</div>   
<% 

DiscoverResult qResults = (DiscoverResult)request.getAttribute("queryresults");
Item      [] items       = (Item[]      )request.getAttribute("items");
Community [] communities = (Community[] )request.getAttribute("communities");

if( error )
{
 %>
	<p align="center" class="submitFormWarn">
		<fmt:message key="jsp.search.error.discovery" />
	</p>
	<%
}
else if( qResults != null && qResults.getTotalSearchResults() == 0 )
{
 %>
    <%-- <p align="center">Search produced no results.</p> --%>
    <p align="center"><fmt:message key="jsp.search.general.noresults"/></p>
<%
}
else if( qResults != null)
{
    long pageTotal   = ((Long)request.getAttribute("pagetotal"  )).longValue();
    long pageCurrent = ((Long)request.getAttribute("pagecurrent")).longValue();
    long pageLast    = ((Long)request.getAttribute("pagelast"   )).longValue();
    long pageFirst   = ((Long)request.getAttribute("pagefirst"  )).longValue();
    
    // create the URLs accessing the previous and next search result pages
    String baseURL =  request.getContextPath()
                    + (searchScopeTemp != "" ? "/handle/" + searchScopeTemp : "")
                    + "/simple-search?query="
                    + URLEncoder.encode(query,"UTF-8")
                    + httpFilters
                    + "&amp;sort_by=" + sortedBy
                    + "&amp;order=" + order
                    + "&amp;rpp=" + rpp
                    + "&amp;etal=" + etAl
                    + "&amp;start=";

    String nextURL = baseURL;
    String firstURL = baseURL;
    String lastURL = baseURL;

    String prevURL = baseURL
            + (pageCurrent-2) * qResults.getMaxResults();

    nextURL = nextURL
            + (pageCurrent) * qResults.getMaxResults();
    
    firstURL = firstURL +"0";
    lastURL = lastURL + (pageTotal-1) * qResults.getMaxResults();


%>
<hr/>
<div class="discovery-result-pagination row container">
<%
	long lastHint = qResults.getStart()+qResults.getMaxResults() <= qResults.getTotalSearchResults()?
	        qResults.getStart()+qResults.getMaxResults():qResults.getTotalSearchResults();
%>
    <%-- <p align="center">Results <//%=qResults.getStart()+1%>-<//%=qResults.getStart()+qResults.getHitHandles().size()%> of --%>
	<div class="alert alert-info"><fmt:message key="jsp.search.results.results">
        <fmt:param><%=qResults.getStart()+1%></fmt:param>
        <fmt:param><%=lastHint%></fmt:param>
        <fmt:param><%=qResults.getTotalSearchResults()%></fmt:param>
        <fmt:param><%=(float) qResults.getSearchTime() / 1000%></fmt:param>
    </fmt:message></div>
    <ul class="pagination pull-right">
	<%
	if (pageFirst != pageCurrent)
	{
	    %><li><a href="<%= prevURL %>"><fmt:message key="jsp.search.general.previous" /></a></li><%
	}
	else
	{
	    %><li class="disabled"><span><fmt:message key="jsp.search.general.previous" /></span></li><%
	}
	
	if (pageFirst != 1)
	{
	    %><li><a href="<%= firstURL %>">1</a></li><li>...</li><%
	}
	
	for( long q = pageFirst; q <= pageLast; q++ )
	{
	    String myLink = "<li><a href=\""
	                    + baseURL;
	
	
	    if( q == pageCurrent )
	    {
	        myLink = "<li class=\"active\"><span>" + q + "</span></li>";
	    }
	    else
	    {
	        myLink = myLink
	            + (q-1) * qResults.getMaxResults()
	            + "\">"
	            + q
	            + "</a></li>";
	    }
	%>
	
	<%= myLink %>

	<%
	}
	
	if (pageTotal > pageLast)
	{
	    %><li class="disabled"><span>...</span></li><li><a href="<%= lastURL %>"><%= pageTotal %></a></li><%
	}
	if (pageTotal > pageCurrent)
	{
	    %><li><a href="<%= nextURL %>"><fmt:message key="jsp.search.general.next" /></a></li><%
	}
	else
	{
	    %><li class="disabled"><span><fmt:message key="jsp.search.general.next" /></span></li><%
	}
	%>
	</ul>
<!-- give a content to the div -->
</div>
<div class="discovery-result-results">
<% if (communities.length > 0 ) { %>
    <div class="panel panel-info">
    <div class="panel-heading"><fmt:message key="jsp.search.results.comhits"/></div>
    <dspace:communitylist  communities="<%= communities %>" />
    </div>
<% } %>

<% if (collections != null && collections.length > 0 ) { %>
    <div class="panel panel-info">
    <div class="panel-heading"><fmt:message key="jsp.search.results.colhits"/></div>
    <dspace:collectionlist collections="<%= collections %>" />
    </div>
<% } %>

<% if (items.length > 0) { %>
    <div class="panel panel-info">
    <div class="panel-heading"><fmt:message key="jsp.search.results.itemhits"/></div>
    <dspace:itemlist items="<%= items %>" authorLimit="<%= etAl %>" />
    </div>
<% } %>
</div>
<%-- if the result page is enought long... --%>
<% if ((communities.length + collections.length + items.length) > 10) {%>
<%-- show again the navigation info/links --%>
<div class="discovery-result-pagination row container">
    <%-- <p align="center">Results <//%=qResults.getStart()+1%>-<//%=qResults.getStart()+qResults.getHitHandles().size()%> of --%>
	<div class="alert alert-info"><fmt:message key="jsp.search.results.results">
        <fmt:param><%=qResults.getStart()+1%></fmt:param>
        <fmt:param><%=lastHint%></fmt:param>
        <fmt:param><%=qResults.getTotalSearchResults()%></fmt:param>
        <fmt:param><%=(float) qResults.getSearchTime() / 1000 %></fmt:param>
    </fmt:message></div>
    <ul class="pagination pull-right">
<%
if (pageFirst != pageCurrent)
{
    %><li><a href="<%= prevURL %>"><fmt:message key="jsp.search.general.previous" /></a></li><%
}
else
{
    %><li class="disabled"><span><fmt:message key="jsp.search.general.previous" /></span></li><%
}    

if (pageFirst != 1)
{
    %><li><a href="<%= firstURL %>">1</a></li><li class="disabled"><span>...<span></li><%
}

for( long q = pageFirst; q <= pageLast; q++ )
{
    String myLink = "<li><a href=\""
                    + baseURL;


    if( q == pageCurrent )
    {
        myLink = "<li class=\"active\"><span>" + q + "</span></li>";
    }
    else
    {
        myLink = myLink
            + (q-1) * qResults.getMaxResults()
            + "\">"
            + q
            + "</a></li>";
    }
%>

<%= myLink %>

<%
}

if (pageTotal > pageLast)
{
    %><li class="disabled"><span>...</span></li><li><a href="<%= lastURL %>"><%= pageTotal %></a></li><%
}
if (pageTotal > pageCurrent)
{
    %><li><a href="<%= nextURL %>"><fmt:message key="jsp.search.general.next" /></a></li><%
}
else
{
    %><li class="disabled"><span><fmt:message key="jsp.search.general.next" /></span></li><%
}
%>
</ul>
<!-- give a content to the div -->
</div>
<% } %>
<% } %>
<dspace:sidebar>
<%
	Map<String, Boolean> showFacets = new HashMap<String, Boolean>();
		
	for (DiscoverySearchFilterFacet facetConf : facetsConf)
	{
	    String f = facetConf.getIndexFieldName();
	    List<FacetResult> facet = qResults != null ? qResults.getFacetResult(f) : new ArrayList<FacetResult>();
	    if (facet.size() == 0)
	    {
	        facet = qResults != null ? qResults.getFacetResult(f+".year"):null;
		    if (facet != null && facet.size() == 0)
		    {
		        showFacets.put(f, false);
		        continue;
		    }
	    }
	    boolean showFacet = false;
	    if(facet != null) {
		    for (FacetResult fvalue : facet)
		    { 
				if(!appliedFilterQueries.contains(f+"::"+fvalue.getFilterType()+"::"+fvalue.getAsFilterQuery()))
			    {
			        showFacet = true;
			        break;
			    }
		    }
	    }
	    showFacets.put(f, showFacet);
	    brefine = brefine || showFacet;
	}
	if (brefine) {
%>

<h3 class="facets"><fmt:message key="jsp.search.facet.refine" /></h3>
<div id="facets" class="facetsBox">

<%
	for (DiscoverySearchFilterFacet facetConf : facetsConf)
	{
	    String f = facetConf.getIndexFieldName();
	    if (!showFacets.get(f))
	        continue;
	    List<FacetResult> facet = qResults.getFacetResult(f);
	    if (facet.size() == 0)
	    {
	        facet = qResults.getFacetResult(f+".year");
	    }
	    int limit = facetConf.getFacetLimit()+1;
	    
	    String fkey = "jsp.search.facet.refine."+f;
	    %><div id="facet_<%= f %>" class="panel panel-success">
	    <div class="panel-heading"><fmt:message key="<%= fkey %>" /></div>
	    <ul class="list-group"><%
	    int idx = 1;
	    int currFp = UIUtil.getIntParameter(request, f+"_page");
	    if (currFp < 0)
	    {
	        currFp = 0;
	    }
	    for (FacetResult fvalue : facet)
	    { 
	        if (idx != limit && !appliedFilterQueries.contains(f+"::"+fvalue.getFilterType()+"::"+fvalue.getAsFilterQuery()))
	        {
	        %><li class="list-group-item"><span class="badge"><%= fvalue.getCount() %></span> <a href="<%= request.getContextPath()
                + (searchScopeTemp!=""?"/handle/"+searchScopeTemp:"")
                + "/simple-search?query="
                + URLEncoder.encode(query,"UTF-8")
                + "&amp;sort_by=" + sortedBy
                + "&amp;order=" + order
                + "&amp;rpp=" + rpp
                + httpFilters
                + "&amp;etal=" + etAl
                + "&amp;filtername="+URLEncoder.encode(f,"UTF-8")
                + "&amp;filterquery="+URLEncoder.encode(fvalue.getAsFilterQuery(),"UTF-8")
                + "&amp;filtertype="+URLEncoder.encode(fvalue.getFilterType(),"UTF-8") %>"
                title="<fmt:message key="jsp.search.facet.narrow"><fmt:param><%=fvalue.getDisplayedValue() %></fmt:param></fmt:message>">
                <%= StringUtils.abbreviate(fvalue.getDisplayedValue(),36) %></a></li><%
                idx++;
	        }
	        if (idx > limit)
	        {
	            break;
	        }
	    }
	    if (currFp > 0 || idx == limit)
	    {
	        %><li class="list-group-item"><span style="visibility: hidden;">.</span>
	        <% if (currFp > 0) { %>
	        <a class="pull-left" href="<%= request.getContextPath()
	            + (searchScopeTemp!=""?"/handle/"+searchScopeTemp:"")
                + "/simple-search?query="
                + URLEncoder.encode(query,"UTF-8")
                + "&amp;sort_by=" + sortedBy
                + "&amp;order=" + order
                + "&amp;rpp=" + rpp
                + httpFilters
                + "&amp;etal=" + etAl  
                + "&amp;"+f+"_page="+(currFp-1) %>"><fmt:message key="jsp.search.facet.refine.previous" /></a>
            <% } %>
            <% if (idx == limit) { %>
            <a href="<%= request.getContextPath()
	            + (searchScopeTemp!=""?"/handle/"+searchScopeTemp:"")
                + "/simple-search?query="
                + URLEncoder.encode(query,"UTF-8")
                + "&amp;sort_by=" + sortedBy
                + "&amp;order=" + order
                + "&amp;rpp=" + rpp
                + httpFilters
                + "&amp;etal=" + etAl  
                + "&amp;"+f+"_page="+(currFp+1) %>"><span class="pull-right"><fmt:message key="jsp.search.facet.refine.next" /></span></a>
            <%
            }
            %></li><%
	    }
	    %></ul></div><%
	}

%>

</div>
<% } %>
</dspace:sidebar>

