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

<%@page import="org.dspace.utils.EdmarUtils"%>
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


<div class="discovery-search-form panel panel-default" style="margin-top: 20px;">
    <%-- Controls for a repeat search --%>
	<div class="discovery-query panel-heading">
    <form action="/jspui/simple-search" method="get">
         
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
                               <%
                               	int iTemp = 1;
                                for (DiscoverySearchFilter searchFilterTemp : availableFilters) { 
                                	String codigoMsgTemp = "jsp.pesquisa.byedmar." + searchFilterTemp.getIndexFieldName();
                                	
                                	
                                %>
                               
                               	<div class="col-lg-3">
									<label for="filter_value_<%=iTemp%>" class="control-label"><fmt:message 
											 key="<%= codigoMsgTemp %>" /></label>
								</div>
								<select id="filter_field_<%=iTemp%>" name="filter_field_<%=iTemp%>" hidden="true">
									<option value="<%=searchFilterTemp.getIndexFieldName()%>" selected="selected">Value</option>
								</select>
								<select id="filter_type_<%=iTemp%>" name="filter_type_<%=iTemp%>" hidden="true">
									<option value="contains" selected="selected"><fmt:message
											key="jsp.search.filter.op.contains" /></option>
								</select>
								<% 
                                		if((searchFilterTemp.getMetadataFields().get(0).equals("dc.type") || searchFilterTemp.getMetadataFields().get(0).equals("dc.relation.uri") ) && !EdmarUtils.seColecaoOuComunidadeAtos(searchScopeTemp)) {
                                		%>
                                		<div class="col-lg-9">
									
										<select id="filter_value_<%=iTemp%>" name="filter_value_<%=iTemp%>" class="form-control" value="">
										
											<option value="Artigo de jornal" label="Artigo de jornal"/>
											<option value="Artigo de revista" label="Artigo de revista"/>
											<option value="Capítulo de livro" label="Capítulo de livro"/>
											<option value="Discurso" label="Discurso"/>
											<option value="Dissertação" label="Dissertação"/>
											<option value="Entrevista" label="Entrevista"/>
											<option value="Livro" label="Livro"/>
											<option value="Palestra" label="Palestra"/>
											<option value="Prefácio" label="Prefácio"/>
											<option value="Preprint" label="Preprint"/>
											<option value="Sumário de livro" label="Sumário de livro"/>
											<option value="TCC/Especialização" label="TCC/Especialização"/>
											<option value="Tese" label="Tese"/>
											<option value="Outros" label="Outros"/>
											
											
											
										
								</option></select>
								</div>
                                		
                                		
                                		<%
                                		
                                		} else if((searchFilterTemp.getMetadataFields().get(0).equals("dc.type") || searchFilterTemp.getMetadataFields().get(0).equals("dc.relation.uri") ) && EdmarUtils.seColecaoOuComunidadeAtos(searchScopeTemp)) {
                                			%>
                                			<div class="col-lg-9">
        									
    										<select id="filter_value_<%=iTemp%>" name="filter_value_<%=iTemp%>" class="form-control" value="">
    										
    											<option value="Ata" label="Ata"/>
    											<option value="Ato regimental" label="Ato regimental"/>
    											<option value="Ato deliberativo" label="Ato deliberativo"/>
    											<option value="Ato regulamentar" label="Ato regulamentar"/>
    											<option value="Acordo de cooperação" label="Acordo de cooperação"/>
    											<option value="Certidão" label="Certidão"/>
    											<option value="Comunicado" label="Comunicado"/>
    											<option value="Despacho" label="Despacho"/>
    											<option value="Edital" label="Edital"/>
    											<option value="Emenda regimental" label="Emenda regimental"/>
    											<option value="Instrução normativa" label="Instrução normativa"/>
    											<option value="Ordem de serviço" label="Ordem de serviço"/>
    											<option value="Orientação normativa" label="Orientação normativa"/>
    											<option value="Portaria" label="Portaria"/>
    											<option value="Portaria conjunta" label="Portaria conjunta"/>
    											<option value="Regimento interno" label="Regimento interno"/>
    											<option value="Resolução" label="Resolução"/>
    											<option value="Termo de homologação" label="Termo de homologação"/>
    											<option value="Outros" label="Outros"/>
    								</option></select>
    								</div>
                                			<%
                                		} else {
                                		
                                			%>
                                	<div class="col-lg-9">
											<input class="form-control" type="text" id="filter_value_<%=iTemp%>"
												name="filter_value_<%=iTemp%>" value="">
										</div>
								
                              		
                               <%
                                		}
                                		
                               iTemp++;
                                }%>
                                
                            
                                <div class="col-lg-3"><label class="control-label" for="query"><fmt:message key="jsp.pesquisa.byedmar.pesquisa.geral"/></label></div>
                                <div class="col-lg-9"><input class="form-control" type="text" size="50" id="query" name="query" value="<%= (query==null ? "" : StringEscapeUtils.escapeHtml(query)) %>"/></div>
                                <input style="float : right;margin-top:20px;" type="submit" id="main-query-submit" class="btn btn-primary" value="Pesquisar" />
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
<a class="btn btn-default" style="margin-top:20px;" href="<%= request.getContextPath()+"/simple-search?location="+searchScopeTemp+"&pesquisa=avancada" %>"><fmt:message key="jsp.pesquisa.byedmar.pesquisaavancada" /></a>
<%if(EdmarUtils.seColecaoOuComunidadeAtos(searchScopeTemp)) {
	%>
	<a style="position: absolute;padding-top: 25px;padding-left: 25px;" href="http://bdjur.stj.jus.br/xmlui/bitstream/handle/2011/79183/dicas_pesquisa_atos.pdf">Dicas de pesquisa</a>
	<% 
} else if(EdmarUtils.seColecaoOuComunidadeDoutrina(searchScopeTemp)) {
%><a style="position: absolute;padding-top: 25px;padding-left: 25px;" href="http://bdjur.stj.jus.br/xmlui/bitstream/id/289160/dicas_pesquisa_doutrina.pdf">Dicas de pesquisa</a>
<% } else {
%>
<a style="position: absolute;padding-top: 25px;padding-left: 25px;" href="http://bdjur.stj.jus.br/xmlui/bitstream/handle/2011/79183/dicas_pesquisa_repositorio.pdf">Dicas de pesquisa</a>
<% }%>
	

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
    <%-- <p align="center">Search produced no results.</p> 
    <%--<p align="center"><fmt:message key="jsp.search.general.noresults"/></p>--%>
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

<%-- if the result page is enought long... --%>
<% if ((communities.length + collections.length + items.length) > 10) {%>
<%-- show again the navigation info/links --%>

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
<% } %>
</dspace:sidebar>

