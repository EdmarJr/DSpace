/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dspace.app.webui.factory.SearchRequestProcessorFactory;
import org.dspace.app.webui.search.SearchProcessorException;
import org.dspace.app.webui.search.SearchRequestProcessor;
import org.dspace.authorize.AuthorizeException;
import org.dspace.core.Context;

/**
 * Servlet for handling a simple search.
 * 
 */
public class SimpleSearchServlet extends DSpaceServlet
{
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private SearchRequestProcessor internalLogic;

    public void init()
    {
        internalLogic = SearchRequestProcessorFactory.getInstanceOfSearchRequestProcessor();
    }

    protected void doDSGet(Context context, HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException,
            SQLException, AuthorizeException
    {
        try
        {
            internalLogic.doSimpleSearch(context, request, response);
        }
        catch (SearchProcessorException e)
        {
            throw new ServletException(e.getMessage(), e);
        }
    }
}
