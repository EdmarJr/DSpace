/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.search;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dspace.core.Context;

public interface SearchRequestProcessorWithManager
{
    
	static final String NOME_METODO_GERENCIAR_REQUESTS_SIMPLE_SEARCH = "gerenciarRequestParaUmSimpleSearch";
	static final Class<?>[] PARAMETROS_METODO_GERENCIAR_REQUESTS = {Context.class,HttpServletRequest.class, HttpServletResponse.class};
	
    public void gerenciarRequestParaUmSimpleSearch(Context context,
			HttpServletRequest request, HttpServletResponse response) throws SearchProcessorException, IOException, ServletException;

}
