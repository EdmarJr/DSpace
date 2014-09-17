/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.factory;

import org.dspace.app.webui.adapter.SearchRequestProcessorWithManagerImpl;
import org.dspace.app.webui.search.SearchRequestProcessorWithManager;

public class SearchRequestProcessorWithManagerFactory {

	public static SearchRequestProcessorWithManager getInstanceOfSearchRequestProcessorWithManager() {
		
		return new SearchRequestProcessorWithManagerImpl(SearchRequestProcessorFactory
				.getInstanceOfSearchRequestProcessor().getClass(),
				SearchRequestProcessorFactory
						.getInstanceOfSearchRequestProcessor());
	}

}
