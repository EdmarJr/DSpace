/**
 * The contents of this file are subject to the license and copyright
 * detailed in the LICENSE and NOTICE files at the root of the source
 * tree and available online at
 *
 * http://www.dspace.org/license/
 */
package org.dspace.app.webui.util;

public enum AvaliacaoBDjurEnum {
	PESSIMO("p","Péssimo"), RUIM("r","Ruim"), BOM("b","Bom"), OTIMO("o","Ótimo"); 
	
	private String label;
	private String caractereRepresentacao;

	private AvaliacaoBDjurEnum(String caractereRepresentacao, String label) {
		this.caractereRepresentacao = caractereRepresentacao;
		this.label = label;
		// TODO Auto-generated constructor stub
	}
	
	
	public static String obterLabelPorString(String caractereRepresentacao) {
		for(AvaliacaoBDjurEnum t :AvaliacaoBDjurEnum.values()) {
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
