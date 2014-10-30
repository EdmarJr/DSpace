/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */

package org.dspace.utils;

public class EdmarUtils {
	
	public static Boolean seColecaoOuComunidadeDoutrina(String handle) {
		Integer ultimoNumero = Integer.parseInt(obterUltimosNumeros(handle));
		if(ultimoNumero.equals(2) || (ultimoNumero > 7) &&  (ultimoNumero < 18)) {
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}

	public static Boolean seColecaoOuComunidadeAtos(String handle) {
		Integer ultimoNumero = Integer.parseInt(obterUltimosNumeros(handle));
		if(ultimoNumero.equals(1) || (ultimoNumero > 3) &&  (ultimoNumero < 8)) {
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}

	public static Boolean seColecaoOuComunidadeRepositorio(String handle) {
		Integer ultimoNumero = Integer.parseInt(obterUltimosNumeros(handle));
		if(ultimoNumero.equals(3) || (ultimoNumero > 17) &&  (ultimoNumero < 23)) {
			return Boolean.TRUE;
		}
		return Boolean.FALSE;
	}
	
	private static String obterUltimosNumeros(String handle) {
		String ultimosNumeros = handle.split("/")[1];
		return ultimosNumeros;
	}
}
