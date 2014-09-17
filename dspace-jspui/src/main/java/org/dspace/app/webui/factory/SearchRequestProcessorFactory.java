/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.factory;

import org.apache.log4j.Logger;
import org.dspace.app.webui.discovery.DiscoverySearchRequestProcessor;
import org.dspace.app.webui.search.SearchRequestProcessor;
import org.dspace.core.PluginConfigurationError;
import org.dspace.core.PluginManager;

public class SearchRequestProcessorFactory {
	
	private static Logger log = Logger.getLogger(SearchRequestProcessorFactory.class);
	private static SearchRequestProcessor internalLogic;
	
	public static SearchRequestProcessor getInstanceOfSearchRequestProcessor() {
		try
        {
            internalLogic = (SearchRequestProcessor) PluginManager
                    .getSinglePlugin(SearchRequestProcessor.class);
        }
        catch (PluginConfigurationError e)
        {
            log.warn(
                    "SearchRequestProcessorFactory not properly configurated, please configure the SearchRequestProcessor plugin",
                    e);
        }
        if (internalLogic == null)
        {   // Discovery is the default search provider since DSpace 4.0
            internalLogic = new DiscoverySearchRequestProcessor();
        }
        return internalLogic;
	}
	
}
