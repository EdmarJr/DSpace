/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.util;

public enum FrequenciaConteudoUteisEnum {
	SEMPRE("s","Sempre"), FREQUENTEMENTE("f","Frequentemente"), AS_VEZES("a","Ás vezes"), NUNCA("n","Nunca"); 
	
	private String label;
	private String caractereRepresentacao;

	private FrequenciaConteudoUteisEnum(String caractereRepresentacao, String label) {
		this.caractereRepresentacao = caractereRepresentacao;
		this.label = label;
		// TODO Auto-generated constructor stub
	}
	
	
	public static String obterLabelPorString(String caractereRepresentacao) {
		for(FrequenciaConteudoUteisEnum t :FrequenciaConteudoUteisEnum.values()) {
			if(t.getCaractereRepresentacao().equals(caractereRepresentacao)){
				return t.getLabel();
			}
		}
		return "";
	}


	public String getLabel() {
		return label;
	}

	public String getCaractereRepresentacao() {
		return caractereRepresentacao;
	}

	
}
