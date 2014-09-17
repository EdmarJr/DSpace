/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.adapter;

import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.dspace.app.webui.search.SearchProcessorException;
import org.dspace.app.webui.search.SearchRequestProcessorWithManager;
import org.dspace.core.Context;

public class SearchRequestProcessorWithManagerImpl implements
		SearchRequestProcessorWithManager {

	private Class<?> clazz;
	private Object instancia;

	public SearchRequestProcessorWithManagerImpl(Class<?> clazz,
			Object instancia) {
		this.clazz = clazz;
		this.instancia = instancia;
	}

	@Override
	public void gerenciarRequestParaUmSimpleSearch(Context context,
			HttpServletRequest request, HttpServletResponse response)
			throws SearchProcessorException, IOException, ServletException {
		try {
			Method method = clazz
					.getMethod(
							SearchRequestProcessorWithManager.NOME_METODO_GERENCIAR_REQUESTS_SIMPLE_SEARCH,
							SearchRequestProcessorWithManager.PARAMETROS_METODO_GERENCIAR_REQUESTS);
			method.invoke(instancia, context, request, response);
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (IllegalAccessException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

}
